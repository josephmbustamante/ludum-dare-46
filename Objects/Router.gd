extends StaticBody2D
class_name Router


export (GlobalEnums.ObjectTypes) var object_type = GlobalEnums.ObjectTypes.ROUTER
export (int, 0, 100) var wifi_level: int = 100 setget set_wifi_level

var current_prompt: Prompt = null

signal request_input(prompt)
signal wifi_level_changed(level)

export (int) var difficulty_multiplier = 0 setget set_difficulty_multiplier
func set_difficulty_multiplier(multiplier):
	difficulty_multiplier = multiplier

func interact():
	var prompt = Prompt.new()
	prompt.prompt = "Enter command: reset_router"
	prompt.response = "reset_router"
	emit_signal("request_input", prompt)


func handle_input_complete(status) -> void:
	if status == true:
		set_wifi_level(100 - difficulty_multiplier * 10)


func set_wifi_level(new_wifi_level):
	var potential_new_wifi_level = clamp(new_wifi_level, 0 ,100)
	if potential_new_wifi_level != wifi_level:
		wifi_level = potential_new_wifi_level
		emit_signal("wifi_level_changed", wifi_level)
