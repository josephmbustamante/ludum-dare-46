extends Node2D
class_name Meeting

export (String) var meeting_name = "Meeting Name Goes Here"


onready var meeting_tick_timer = $MeetingTickTimer
onready var participants = $Participants


func start_meeting():
	meeting_tick_timer.start()


func stop_meeting():
	meeting_tick_timer.stop()


func get_meeting_participants() -> Array:
	return participants.get_children()


func _on_MeetingTickTimer_timeout() -> void:
	for participant in participants.get_children():
		participant.engagement_level -= 0.5
