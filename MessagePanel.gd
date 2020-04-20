extends Node2D
class_name MessagePanel

onready var message_label = $MessageText

func show_message(message) -> void:
	print("GOT show_message call")
	message_label.text = message
	visible = true

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventKey and not event.is_pressed():
		var a: InputEventKey = event
		var key_code = OS.get_scancode_string(event.scancode)

		# If we press Enter or Escape, exit, regardless of progress or session
		if key_code == "Enter" or key_code == "Escape":
			get_tree().set_input_as_handled()
			visible = false
