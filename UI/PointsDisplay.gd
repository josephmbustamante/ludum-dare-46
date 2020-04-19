extends VBoxContainer


onready var points_value_label = $PointsValue

var points: int = 0


func add_points(points_to_add: int):
	var new_point_value = points + points_to_add
	if new_point_value < 0:
		new_point_value = 0

	points = new_point_value
	points_value_label.text = str(points)
