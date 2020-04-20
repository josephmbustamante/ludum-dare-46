extends Node2D
class_name Participant


signal participant_engagement_level_changed(engagement_level)
signal participant_needs_interaction(prompt, response)
signal participant_status_changed(status)
signal participant_left_meeting()

export (String) var first_name = ""
export (String) var last_name = ""
export (float, 0, 100) var engagement_level = 100 setget set_engagement_level
export (String) var status = "" setget set_status


var current_question = null
var current_question_time = 0
var has_left_meeting = false

export (int) var difficulty_multiplier = 0 setget set_difficulty_multiplier
func set_difficulty_multiplier(multiplier):
	difficulty_multiplier = multiplier


func set_engagement_level(new_engagement_level: int):
	if has_left_meeting:
		return

	engagement_level = clamp(new_engagement_level, 0, 100)
	emit_signal("participant_engagement_level_changed", engagement_level)

	randomize()
	if engagement_level == 0:
		has_left_meeting = true
		clear_question()
		emit_signal("participant_left_meeting")

	elif randi() % 101 + 21 > engagement_level and randi() % 8 + difficulty_multiplier >= 8:
		current_question = get_participant_question()
		current_question_time = OS.get_ticks_msec()
		emit_signal("participant_needs_interaction", current_question.prompt, current_question.response)
		set_status("???")


func set_status(new_status: String):
	status = new_status
	emit_signal("participant_status_changed", new_status)


func clear_question():
	current_question = null
	current_question_time = 0
	emit_signal("participant_status_changed", "")

func get_participant_question():
	var questions = [
		{"prompt": "Help! What color is the sky?!", "response": "It's still blue."},
		{"prompt": "Are you still there?", "response": "Yeah, still here."},
		{"prompt": "What day is it?", "response": "Ha, I have no idea."},
		{"prompt": "Stepping away for a moment", "response": "Finally, about time."},
		{"prompt": "... ... (confused look intensifies) ...!!!!", "response": "You're muted!"},
		{"prompt": "Wait, what meeting is this?", "response": "The best one."},
		{"prompt": "When are the TPS reports due?", "response": "By Saturday."},
		{"prompt": "Can we circle back to that last point?", "response": "No, we cannot."},
		{"prompt": "Is this related to a key performance metric?", "response": "What are those?"},
		{"prompt": "Will this have an affect on team velocity?", "response": "Most assuredly."},
		{"prompt": "How can we increase consumer buy-in?", "response": "Nobody cares!"},
		{"prompt": "Do you mind if I punt this until next week?", "response": "Do your job!"},
		{"prompt": "Is this a robust, scalable solution?", "response": "Is this a what?"},
	]

	randomize()
	return questions[randi() % questions.size()]
