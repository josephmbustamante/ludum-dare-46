extends Node2D


onready var animation_player = $AnimationPlayer


func _on_SelectedObjectNotifier_visibility_changed() -> void:
	if visible:
		animation_player.play("hover")
	else:
		animation_player.stop(true)
