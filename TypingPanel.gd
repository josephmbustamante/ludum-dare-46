extends Node2D


onready var prompt_text = $PromptText
onready var input_text = $InputText
onready var input_finished_clear_timer = $InputFinishedClearTimer
onready var shift_forgiveness_timer = $ShiftForgivenessTimer


var text_to_type: String = ""
var current_character_index: int = -1
var requires_completion: bool = false
var current_requestor = null # computer, router, or bed


signal input_finished
signal input_incorrect


func _ready() -> void:
	text_to_type = input_text.text
	current_character_index = -1


func show_typing_session():
	# If we have no session in progress, then start a new one.
	# If we do have a session in progress, resume it.
	#if current_character_index == -1:
	#	reset_typing_session()
	show()


func start_typing_session(prompt: Prompt, requestor, requires_completion: bool = false):
	if prompt != null:
		current_requestor = requestor
		self.requires_completion = requires_completion
		prompt_text.text = prompt.prompt
		input_text.text = prompt.response
		text_to_type = prompt.response
		current_character_index = 0
		visible = true


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
		var typed_event: InputEventKey = event
		var key_code = OS.get_scancode_string(typed_event.scancode).to_lower()

		# If we press Enter or Escape, exit, regardless of progress or session
		if key_code == "enter" or key_code == "escape":
			# If enter or escape are hit, we never want the camera to shake (probably).
			# But we only want to exit the prompt if it doesn't require completion.
			if not requires_completion:
				exit_typing_session()
			else:
				pass

		if key_code == "shift":
			shift_forgiveness_timer.start()

		# If we aren't currently in a valid typing session, don't allow input
		elif current_character_index == -1:
			pass

		# If we haven't finished typing yet and received a character, check if we are done
		# or still have more to go
		elif current_character_index < text_to_type.length():
			var raw_data = PoolByteArray([typed_event.unicode])
			var key_press_string = raw_data.get_string_from_utf8()
			var next_character = text_to_type.substr(current_character_index, 1)

			# If we typed the correct character
			if correct_character_was_typed(key_press_string, next_character):
				current_character_index += 1

				# If this was the last character - we finished
				if current_character_index == text_to_type.length():
					input_text.parse_bbcode("[color=green]" + text_to_type + "[/color]")
					finish_typing_session()

				# We still have more characters to go
				else:
					input_text.parse_bbcode("[u][color=black]" + text_to_type.substr(0, current_character_index) + "[/color][/u]" + text_to_type.substr(current_character_index, -1))

			else:
				if key_code == "shift":
					pass
				else:
					print("INCORRECTLY TYPED %s instead of %s" % [key_press_string, next_character])
					input_text.parse_bbcode("[u][color=black]" + text_to_type.substr(0, current_character_index) + "[/color][color=red]" + text_to_type.substr(current_character_index, 1) + "[/color][/u]" + text_to_type.substr(current_character_index + 1, -1))
					emit_signal("input_incorrect")

	get_tree().set_input_as_handled()


func correct_character_was_typed(typed_character: String, next_character: String):
	var is_shift_timer_going = shift_forgiveness_timer.time_left > 0

	var characters_match: bool = typed_character == next_character
	var characters_match_with_forgiveness: bool = is_shift_timer_going and typed_character.to_upper() == next_character.to_upper()

	# Unfortunately, exclamation marks and question marks aren't the uppercase version of 1 or /
	# so this is the quick and dirty way to help those feel better too.
	var characters_match_exclamation: bool = is_shift_timer_going and typed_character == "1" and next_character == "!"
	var characters_match_question: bool = is_shift_timer_going and typed_character == "/" and next_character == "?"
	return characters_match or characters_match_with_forgiveness or characters_match_exclamation or characters_match_question



func _on_InputFinishedClearTimer_timeout() -> void:
	hide()
	reset_typing_session()
