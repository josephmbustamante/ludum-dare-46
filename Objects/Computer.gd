extends StaticBody2D


export (GlobalEnums.ObjectTypes) var object_type = GlobalEnums.ObjectTypes.COMPUTER


var current_meeting: Meeting = null
var current_prompt: ParticipantPrompt = null
signal request_input(prompt)


func interact():
	if current_meeting != null:
		print("Emitting request input")
		current_prompt = current_meeting.get_oldest_prompt()
		emit_signal("request_input", current_prompt)
	# else:
		# TODO: trigger an informational message that says there's nothing to do
		# with the computer right now. Wait for a meeting to start.


func set_current_meeting(meeting: Meeting):
	print("Set current meeting %s" % meeting)
	current_meeting = meeting
	current_prompt = null


func handle_input_complete(status) -> void:
	if current_meeting != null:
		current_meeting.handle_prompt_completed(current_prompt, status)
