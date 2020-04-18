extends Node2D


onready var input_text = $InputText


var text_to_type: String = ""
var current_character_index: int = -1


func _ready() -> void:
	text_to_type = input_text.text
	current_character_index = 0


func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var a: InputEventKey = event
		var key_press_string = OS.get_scancode_string(a.scancode)
		var next_character = text_to_type.substr(current_character_index, 1)
		if key_press_string == next_character:
			print("CORRECTLY TYPED %s" % key_press_string)
			current_character_index += 1
		else:
			print("INCORRECTLY TYPED %s instead of %s" % [key_press_string, next_character])

	get_tree().set_input_as_handled()
