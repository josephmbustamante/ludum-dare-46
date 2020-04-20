extends Node2D
class_name MessagePanel

onready var message_label = $MessageText
onready var animation_player = $AnimationPlayer


var is_open: bool = false


func show_message(message) -> void:
	print("GOT show_message call")
	message_label.text = message
	animation_player.play("show")
	is_open = true

func _input(event: InputEvent) -> void:
	if not is_open:
		return

	if event is InputEventKey and not event.is_pressed():
		var a: InputEventKey = event
		var key_code = OS.get_scancode_string(event.scancode)

		# If we press Enter or Escape, exit, regardless of progress or session
		if key_code == "Enter" or key_code == "Escape":
			get_tree().set_input_as_handled()
			animation_player.stop()
			modulate = Color(1, 1, 1, 0)
			is_open = false


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "show":
		is_open = false
