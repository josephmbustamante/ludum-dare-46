tool
extends ProgressBar


export (Color) var high_color
export (Color) var medium_color
export (Color) var low_color
export (Color) var very_low_color


var fill_resource: Resource


func _ready() -> void:
	fill_resource = get("custom_styles/fg")


func _process(delta: float) -> void:
	if value > 75:
		fill_resource.set("bg_color", high_color)
	elif value > 50:
		fill_resource.set("bg_color", medium_color)
	elif value > 25:
		fill_resource.set("bg_color", low_color)
	else:
		fill_resource.set("bg_color", very_low_color)
