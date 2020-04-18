extends Node2D
class_name Meeting

export (String) var meeting_name = ""


onready var meeting_tick_timer = $MeetingTickTimer
onready var participants = $Participants


var is_meeting_running: bool = true


func start_meeting():
	meeting_tick_timer.start()


func stop_meeting():
	meeting_tick_timer.stop()


func is_meeting_running() -> bool:
	return is_meeting_running


func get_meeting_participants() -> Array:
	return participants.get_children()


func _on_MeetingTickTimer_timeout() -> void:
	print("Meeting tick!")
