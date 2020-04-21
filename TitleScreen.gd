extends Node2D


onready var tutorials = $Tutorials
onready var tutorial_button = $ShowTutorialButton
onready var title = $Title
onready var title_background = $TitleBackground
onready var background_image = $BackgroundImage
onready var play_button = $PlayButton


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")


func _on_ShowTutorialButton_pressed() -> void:
	if tutorials.visible:
		tutorials.hide()
		title.show()
		title_background.show()
		play_button.show()
		background_image.modulate = Color(0.639216, 0.686275, 0.933333, 0.196078)
		tutorial_button.text = "SHOW TUTORIALS"
	else:
		tutorials.show()
		title.hide()
		title_background.hide()
		play_button.hide()
		background_image.modulate = Color(1, 1, 1, 1)
		tutorial_button.text = "HIDE TUTORIALS"
