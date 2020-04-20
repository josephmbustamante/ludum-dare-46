extends Node2D


onready var final_score_value = $FinalScoreValue
onready var rating_value = $RatingValue


func update_game_over_screen(final_score: int):
	final_score_value.text = str(final_score)
	set_rating_text(final_score)


func set_rating_text(rating: int):
	if rating >= 800:
		rating_value.text = "MASTERFUL"
		rating_value.set("custom_colors/font_color", Color.purple)
	elif rating >= 700:
		rating_value.text = "EXCELLENT"
		rating_value.set("custom_colors/font_color", Color.blue)
	elif rating >= 600:
		rating_value.text = "VERY GOOD"
		rating_value.set("custom_colors/font_color", Color.forestgreen)
	elif rating >= 500:
		rating_value.text = "GOOD"
		rating_value.set("custom_colors/font_color", Color.lime)
	elif rating >= 400:
		rating_value.text = "AVERAGE"
		rating_value.set("custom_colors/font_color", Color.yellow)
	elif rating >= 300:
		rating_value.text = "OKAY"
		rating_value.set("custom_colors/font_color", Color.orange)
	elif rating >= 200:
		rating_value.text = "POOR"
		rating_value.set("custom_colors/font_color", Color.orangered)
	elif rating >= 100:
		rating_value.text = "VERY POOR"
		rating_value.set("custom_colors/font_color", Color.red)
	else:
		rating_value.text = "TERRIBLE"
		rating_value.set("custom_colors/font_color", Color.gray)
