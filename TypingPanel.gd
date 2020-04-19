extends Node2D


onready var prompt_text = $PromptText
onready var input_text = $InputText
onready var input_finished_clear_timer = $InputFinishedClearTimer


var text_to_type: String = ""
var current_character_index: int = -1


signal input_finished


func _ready() -> void:
	text_to_type = input_text.text
	current_character_index = 0


func show_typing_session():
	# If we have no session in progress, then start a new one.
	# If we do have a session in progress, resume it.
	if current_character_index != -1:
		start_typing_session()
	show()


func start_typing_session():
	prompt_text.text = "Help! What color is the sky?"
	var text_to_input = "Everyone knows it is blue."
	input_text.text = text_to_input
	text_to_type = text_to_input

	current_character_index = 0


func reset_typing_session():
	prompt_text.text = "No current messages to respond to."
	input_text.text = ""
	current_character_index = -1


func finish_typing_session():
	emit_signal("input_finished")
	input_finished_clear_timer.start()


func exit_typing_session():
	hide()


func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventKey and not event.is_pressed():
		var a: InputEventKey = event
		var key_code = OS.get_scancode_string(event.scancode)

		# If we press Enter or Escape, exit, regardless of progress or session
		if key_code == "Enter" or key_code == "Escape":
			exit_typing_session()

		# If we aren't currently in a valid typing session, don't allow input
		elif current_character_index == -1:
			pass

		# If we haven't finished typing yet and received a character, check if we are done
		# or still have more to go
		elif current_character_index < text_to_type.length():
			var raw_data = PoolByteArray([a.unicode])
			var key_press_string = raw_data.get_string_from_utf8()
			var next_character = text_to_type.substr(current_character_index, 1)

			# If we typed the correct character
			if key_press_string == next_character:
				current_character_index += 1

				# If this was the last character - we finished
				if current_character_index == text_to_type.length():
					input_text.parse_bbcode("[color=green]" + text_to_type + "[/color]")
					finish_typing_session()

				# We still have more characters to go
				else:
					input_text.parse_bbcode("[u][color=black]" + text_to_type.substr(0, current_character_index) + "[/color][/u]" + text_to_type.substr(current_character_index, -1))

			else:
				print("INCORRECTLY TYPED %s instead of %s" % [key_press_string, next_character])
				input_text.parse_bbcode("[u][color=black]" + text_to_type.substr(0, current_character_index) + "[/color][color=red]" + text_to_type.substr(current_character_index, 1) + "[/color][/u]" + text_to_type.substr(current_character_index + 1, -1))

	get_tree().set_input_as_handled()


func _on_InputFinishedClearTimer_timeout() -> void:
	reset_typing_session()
