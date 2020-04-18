extends Node2D


signal meeting_started(meeting)
signal meeting_finished


onready var new_meeting_timer = $NewMeetingTimer


var meeting_scene = preload("res://Meeting.tscn")
var meeting: Meeting = null

var time_between_meetings: int = 10 # seconds
var time_until_next_meeting: int = -1 #seconds


func begin_new_meeting_timer():
	new_meeting_timer.start()
	time_until_next_meeting = time_between_meetings


func start_meeting() -> Meeting:
	meeting = meeting_scene.instance()
	add_child(meeting)
	meeting.start_meeting()
	emit_signal("meeting_started", meeting)
	return meeting


func finish_meeting():
	if meeting != null:
		meeting.queue_free()
		meeting = null
		emit_signal("meeting_finished")

	begin_new_meeting_timer()


func get_current_meeting() -> Meeting:
	return meeting


func _on_NewMeetingTimer_timeout() -> void:
	time_until_next_meeting -= 1
	if time_until_next_meeting == 0:
		start_meeting()
		new_meeting_timer.stop()
