extends Node2D


onready var meeting_tick_timer = $MeetingTickTimer


var is_meeting_running: bool = true


func start_meeting():
	meeting_tick_timer.start()


func stop_meeting():
	meeting_tick_timer.stop()


func is_meeting_running() -> bool:
	return is_meeting_running


func _on_MeetingTickTimer_timeout() -> void:
	print("Meeting tick!")
