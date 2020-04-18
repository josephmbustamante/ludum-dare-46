extends Node2D
class_name Meeting


signal meeting_duration_changed(new_duration)
signal meeting_finished


export (String) var meeting_name = "Meeting Name Goes Here"
export (int) var meeting_duration = 60


onready var meeting_tick_timer = $MeetingTickTimer
onready var participants = $Participants


func start_meeting():
	meeting_tick_timer.start()


func finish_meeting():
	meeting_tick_timer.stop()


func get_meeting_participants() -> Array:
	return participants.get_children()


func _on_MeetingTickTimer_timeout() -> void:
	for participant in participants.get_children():
		participant.engagement_level -= 0.5

	meeting_duration -= 1
	emit_signal("meeting_duration_changed", meeting_duration)
	if meeting_duration == 0:
		finish_meeting()
		emit_signal("meeting_finished")
