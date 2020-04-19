extends PanelContainer


onready var animation_player = $AnimationPlayer
onready var recap_display_timer = $RecapDisplayTimer

onready var breakdown_rows = $MarginContainer/Rows/BreakdownRows
onready var total_points_value = $MarginContainer/Rows/TotalPointsRow/TotalPointsValue


var breakdown_row_scene = preload("res://UI/PointBreakdownRow.tscn")


func _ready() -> void:
	modulate = Color(1, 1, 1, 0)


func set_meeting_recap_display(point_breakdowns: Array, total_points: int):
	for breakdown in breakdown_rows.get_children():
		breakdown.queue_free()

	for breakdown in point_breakdowns:
		var new_row = breakdown_row_scene.instance()
		breakdown_rows.add_child(new_row)
		new_row.set_point_change_label(breakdown.value)
		new_row.set_reason_label(breakdown.reason)

	if total_points > 0:
		total_points_value.set("custom_colors/font_color", Color.green)
	elif total_points < 0:
		total_points_value.set("custom_colors/font_color", Color.red)
	else:
		total_points_value.set("custom_colors/font_color", Color.white)

	total_points_value.text = str(total_points)

	animation_player.play("show")


func hide_meeting_recap_display():
	animation_player.play("hide")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"show":
			recap_display_timer.start()


func _on_RecapDisplayTimer_timeout() -> void:
	hide_meeting_recap_display()
