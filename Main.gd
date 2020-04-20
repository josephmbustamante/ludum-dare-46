extends Node2D


onready var camera = $Camera2D
onready var player = $GroundYSort/Player

onready var meeting_manager = $MeetingManager
onready var room_manager = $RoomManager

onready var computer = $OnTableYSort/Computer
onready var router = $OnTableYSort/Router
onready var bed = $GroundYSort/Bed

onready var points_display = $CanvasLayer/GameUI/MarginContainer/Rows/BottomRow/PointsDisplay
onready var meeting_display = $CanvasLayer/GameUI/MarginContainer/Rows/BottomRow/MeetingDisplay
onready var room_display = $CanvasLayer/GameUI/MarginContainer/Rows/BottomRow/RoomDisplay
onready var meeting_recap_display = $CanvasLayer/GameUI/MarginContainer/Rows/MiddleRow/VBoxContainer/MeetingRecapDisplay

onready var selected_object_notifier = $SelectedObjectNotifier
onready var typing_panel = $TypingPanel
onready var message_panel = $MessagePanel


var interactable_objects: Array = []
var currently_selected_object_index: int = -1
var current_input_requestor = null;

var points: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currently_selected_object_index = -1

	meeting_manager.begin_new_meeting_timer()
	meeting_manager.connect("meeting_started", self, "handle_meeting_started")
	meeting_manager.connect("meeting_finished", self, "handle_meeting_finished")
	meeting_manager.connect("time_until_next_meeting_changed", meeting_display, "set_time_until_next_meeting_text")

	room_manager.set_router(router)
	router.connect("wifi_level_changed", self, "handle_wifi_level_changed")
	bed.set_player(player)

	computer.connect("request_input", self, "handle_input_request", [computer])
	computer.connect("show_message", self, "handle_show_message")
	router.connect("request_input", self, "handle_input_request", [router])
	bed.connect("request_input", self, "handle_input_request", [bed])
	typing_panel.connect("input_finished", self, "handle_input_complete")
	typing_panel.connect("input_incorrect", camera, "add_trauma")

func handle_show_message(message):
	print("Got message: %s" % message)
	message_panel.show_message(message)

func handle_wifi_level_changed(level):
	room_display.handle_wifi_level_changed(level)
	computer.handle_wifi_level_changed(level)
	
func handle_input_request(prompt, requestor) -> void:
	current_input_requestor = requestor
	var prompt_requires_completion = false

	if requestor == bed:
		prompt_requires_completion = true

	typing_panel.start_typing_session(prompt, prompt_requires_completion)


func handle_input_complete() -> void:
	print("Handling input complete")
	current_input_requestor.handle_input_complete(true)
	current_input_requestor = null


func handle_meeting_started(meeting: Meeting, number: int):
	meeting_display.set_meeting_display(meeting)
	computer.set_current_meeting(meeting)
	router.set_difficulty_multiplier(number)
	player.set_difficulty_multiplier(number)
	meeting.set_difficulty_multiplier(number)


func handle_meeting_finished(point_breakdowns: Array, total_points: int):
	var new_point_value = total_points + points
	if new_point_value < 0:
		new_point_value = 0
	points = new_point_value

	computer.set_current_meeting(null)
	meeting_recap_display.set_meeting_recap_display(point_breakdowns, total_points)
	points_display.update_points(points)


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
		object_to_interact.interact()


func _on_Player_player_stress_level_changed(new_stress_level) -> void:
	room_display.handle_stress_level_changed(new_stress_level)
