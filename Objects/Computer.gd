extends StaticBody2D


export (GlobalEnums.ObjectTypes) var object_type = GlobalEnums.ObjectTypes.COMPUTER


var current_meeting: Meeting = null
var current_prompt: ParticipantPrompt = null
var wifi_works: bool = true
signal request_input(prompt)
signal show_message(message)


func interact():
	if !wifi_works:
		print("No Wifi!")
		emit_signal("show_message", "ERROR: No wifi signal")
	elif current_meeting != null:
		print("Emitting request input")
		current_prompt = current_meeting.get_oldest_prompt()
		if current_prompt == null:
			emit_signal("show_message", "Nobody has a question yet!")
		else:
			emit_signal("request_input", current_prompt)
	else:
		print("NO MEETING")
		emit_signal("show_message", "No meeting in progress")

func set_current_meeting(meeting: Meeting):
	print("Set current meeting %s" % meeting)
	current_meeting = meeting
	current_prompt = null


func handle_input_complete(status) -> void:
	if current_meeting != null:
		current_meeting.handle_prompt_completed(current_prompt, status)

func handle_wifi_level_changed(level: int):
	if (level == 0):
		wifi_works = false
	else:
		wifi_works = true
