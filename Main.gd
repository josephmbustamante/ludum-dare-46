extends Node2D


onready var meeting_manager = $MeetingManager
onready var room_manager = $RoomManager

onready var selected_object_notifier = $SelectedObjectNotifier
onready var meeting_display = $CanvasLayer/GameUI/MarginContainer/Rows/BottomRow/MeetingDisplay
onready var room_display = $CanvasLayer/GameUI/MarginContainer/Rows/BottomRow/RoomDisplay
onready var typing_panel = $TypingPanel


var interactable_objects: Array = []
var currently_selected_object_index: int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currently_selected_object_index = -1

	meeting_manager.begin_new_meeting_timer()
	meeting_manager.connect("meeting_started", self, "handle_meeting_started")
	meeting_manager.connect("time_until_next_meeting_changed", meeting_display, "set_time_until_next_meeting_text")

	room_manager.connect("wifi_level_changed", room_display, "handle_wifi_level_changed")


func handle_meeting_started(meeting: Meeting):
	meeting_display.set_meeting_display(meeting)
	typing_panel.start_typing_session()



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_focus_next"):
		if interactable_objects.size() > 0:
			if currently_selected_object_index == interactable_objects.size() - 1:
				currently_selected_object_index += 1
			else:
				currently_selected_object_index = 0
			show_selected_object_notifier(interactable_objects[currently_selected_object_index].global_position)

	if event.is_action_released("ui_focus_prev"):
		if interactable_objects.size() > 0:
			if currently_selected_object_index == 0:
				currently_selected_object_index = interactable_objects.size() - 1
			else:
				currently_selected_object_index -= 1
			show_selected_object_notifier(interactable_objects[currently_selected_object_index].global_position)


func _on_Player_player_can_interact_with_object(object) -> void:
	interactable_objects.append(object)
	if interactable_objects.size() == 1:
		currently_selected_object_index = 0
		show_selected_object_notifier(interactable_objects[currently_selected_object_index].global_position)


func _on_Player_player_cannot_interact_with_object(object) -> void:
	var index = interactable_objects.find(object)
	if index != -1:
		interactable_objects.remove(index)
		# TODO: probably also need to change the currently selected index when we remove something,
		# but will handle that when it comes up.
		if interactable_objects.size() == 0:
			currently_selected_object_index = -1
			hide_selected_object_notifier()


func show_selected_object_notifier(location: Vector2):
	selected_object_notifier.show()
	selected_object_notifier.global_position = location + Vector2(0, -20)


func hide_selected_object_notifier():
	selected_object_notifier.hide()


func _on_Player_player_interacted_with_object() -> void:
	if currently_selected_object_index != -1:
		var object_to_interact = interactable_objects[currently_selected_object_index]
		var object_type: int = object_to_interact.interact()
		handle_object_interaction(object_type)


func handle_object_interaction(object_type: int):
	match object_type:
		GlobalEnums.ObjectTypes.COMPUTER:
			print("computer")
			typing_panel.show_typing_session()
			return
		GlobalEnums.ObjectTypes.ROUTER:
			print("router")
			return
		_:
			print("Tried to interact with something we don't have handling for!")
			return
