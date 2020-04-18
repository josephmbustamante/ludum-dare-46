extends Node2D


onready var selected_object_notifier = $SelectedObjectNotifier


var interactable_objects: Array = []
var currently_selected_object_index: int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	interactable_objects.remove(object)
	if interactable_objects.size() == 0:
		currently_selected_object_index = -1
		hide_selected_object_notifier()


func show_selected_object_notifier(location: Vector2):
	selected_object_notifier.show()
	selected_object_notifier.global_position = location + Vector2(0, -20)


func hide_selected_object_notifier():
	selected_object_notifier.hide()
