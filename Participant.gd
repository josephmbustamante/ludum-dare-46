extends Node2D
class_name Participant


signal participant_engagement_level_changed(engagement_level)


export (String) var first_name = ""
export (String) var last_name = ""
export (int, 0, 100) var engagement_level = 100 setget set_engagement_level


func set_engagement_level(new_engagement_level: int):
	engagement_level = clamp(new_engagement_level, 0, 100)
	emit_signal("participant_engagement_level_changed", engagement_level)


