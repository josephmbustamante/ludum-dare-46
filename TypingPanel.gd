extends Node2D


onready var input_text = $InputText


var text_to_type: String = ""
var current_character_index: int = -1
var matched: bool = false

signal input_finished(matched)


func _ready() -> void:
	text_to_type = input_text.text
	current_character_index = 0


func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey and not event.is_pressed():
			var a: InputEventKey = event
			var key_code = OS.get_scancode_string(event.scancode)
	
			if key_code == "Enter" or key_code == "Escape":
				print("DONE")
				emit_signal("input_finished", matched)
			elif current_character_index < text_to_type.length():
				var raw_data = PoolByteArray([a.unicode])
				var key_press_string = raw_data.get_string_from_utf8()
				var next_character = text_to_type.substr(current_character_index, 1)
	
				if key_press_string == next_character:
					current_character_index += 1
					if current_character_index == text_to_type.length() - 1:
						input_text.parse_bbcode("[color=green]" + text_to_type + "[/color]")
						matched = true
					else:
						input_text.parse_bbcode("[u][color=black]" + text_to_type.substr(0, current_character_index) + "[/color][/u]" + text_to_type.substr(current_character_index, -1))
				else:
					print("INCORRECTLY TYPED %s instead of %s" % [key_press_string, next_character])
					input_text.parse_bbcode("[u][color=black]" + text_to_type.substr(0, current_character_index) + "[/color][color=red]" + text_to_type.substr(current_character_index, 1) + "[/color][/u]" + text_to_type.substr(current_character_index + 1, -1))
	
		get_tree().set_input_as_handled()
