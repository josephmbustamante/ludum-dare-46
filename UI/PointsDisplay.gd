extends VBoxContainer


onready var points_value_label = $PointsValue


func update_points(new_points: int):
	points_value_label.text = str(new_points)
