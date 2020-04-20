extends Node2D


signal meeting_started(meeting, meeting_number)
signal meeting_finished(point_breakdowns, total_points)
signal time_until_next_meeting_changed(seconds_remaining)


export (int) var time_between_meetings: int = 10 # seconds


onready var new_meeting_timer = $NewMeetingTimer


var player_points: int = 0

var meeting_scene = preload("res://Meeting.tscn")
var meeting: Meeting = null
var meeting_count = 0;

var time_until_next_meeting: int = -1 #seconds

var meeting_name_first_word = [
	"REGIONAL",
	"EXECUTIVE",
	"IMPORTANT",
	"CONFIDENTIAL",
	"ANNUAL",
	"WEEKLY",
	"DAILY",
	"MONTHLY",
	"QUARTERLY"
]

var meeting_name_second_word = [
	"BOARD MEETING",
	"SALES MEETING",
	"MOTIVATIONAL SERIES",
	"SELF-HELP GROUP",
	"ROUND TABLE",
	"GOAL PLANNING",
	"DESIGN WORKSHOP",
	"GROUPTHINK SESSION"
]


func begin_new_meeting_timer():
	new_meeting_timer.start()
	time_until_next_meeting = time_between_meetings


func start_meeting() -> Meeting:
	randomize()
	meeting_count += 1;
	meeting = meeting_scene.instance()
	add_child(meeting)
	var meeting_name = meeting_name_first_word[randi() % meeting_name_first_word.size()] + " " + meeting_name_second_word[randi() % meeting_name_second_word.size()]
	meeting.start_meeting(meeting_name)
	emit_signal("meeting_started", meeting, meeting_count)
	meeting.connect("meeting_finished", self, "finish_meeting")
	return meeting


func finish_meeting(point_breakdowns: Array, total_points: int):
	if meeting != null:
		meeting.queue_free()
		meeting = null
	emit_signal("meeting_finished", point_breakdowns, total_points)
	begin_new_meeting_timer()


func get_current_meeting() -> Meeting:
	return meeting


func _on_NewMeetingTimer_timeout() -> void:
	time_until_next_meeting -= 1
	emit_signal("time_until_next_meeting_changed", time_until_next_meeting)
	if time_until_next_meeting == 0:
		start_meeting()
		new_meeting_timer.stop()
