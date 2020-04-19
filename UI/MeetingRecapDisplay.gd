extends PanelContainer


onready var animation_player = $AnimationPlayer
onready var recap_display_timer = $RecapDisplayTimer


func _ready() -> void:
	modulate = Color(1, 1, 1, 0)


func set_meeting_recap_display(point_breakdowns: Array, total_points: int):
	# do things here
	animation_player.play("show")


func hide_meeting_recap_display():
	animation_player.play("hide")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"show":
			recap_display_timer.start()


func _on_RecapDisplayTimer_timeout() -> void:
	hide_meeting_recap_display()
