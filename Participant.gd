extends Node2D
class_name Participant


signal participant_engagement_level_changed(engagement_level)

export (String) var first_name = ""
export (String) var last_name = ""
export (float, 0, 100) var engagement_level = 100 setget set_engagement_level

var current_question = null
var current_question_time = 0

func set_engagement_level(new_engagement_level: int):
	engagement_level = clamp(new_engagement_level, 0, 100)
	emit_signal("participant_engagement_level_changed", engagement_level)
	if randi() % 101 + 1 > engagement_level:
		current_question = get_participant_question()
		current_question_time = OS.get_ticks_msec()
		emit_signal("participant_needs_interaction", current_question.prompt, current_question.response)
		
func clear_question():
	current_question = null
	current_question_time = 0

func get_participant_question():
	var questions = [
		{"prompt": "What color is the sky?", "response": "Blue, duh"},
		{"prompt": "Are you still there?", "response": "Yeah, still here."}
	]
	return questions[randi() % questions.size()]
