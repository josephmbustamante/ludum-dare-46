extends HBoxContainer


onready var point_change_label = $PointChangeLabel
onready var reason_label = $ReasonLabel


func set_point_change_label(point_change: int):
	if point_change > 0:
		point_change_label.set("custom_colors/font_color", Color.green)
		point_change_label.text = "+" + str(point_change)
	elif point_change < 0:
		point_change_label.set("custom_colors/font_color", Color.red)
		point_change_label.text = "-" + str(point_change)
	else:
		point_change_label.set("custom_colors/font_color", Color.white)
		point_change_label.text = "~" + str(point_change)


func set_reason_label(reason: String):
	reason_label.text = reason
