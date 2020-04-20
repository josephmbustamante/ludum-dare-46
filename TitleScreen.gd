extends Node2D


onready var tutorials = $Tutorials
onready var tutorial_button = $ShowTutorialButton


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")


func _on_ShowTutorialButton_pressed() -> void:
	if tutorials.visible:
		tutorials.hide()
		tutorial_button.text = "SHOW TUTORIALS"
	else:
		tutorials.show()
		tutorial_button.text = "HIDE TUTORIALS"
