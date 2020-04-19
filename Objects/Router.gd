extends StaticBody2D


export (GlobalEnums.ObjectTypes) var object_type = GlobalEnums.ObjectTypes.ROUTER


var current_prompt: Prompt = null
onready var roomManager: RoomManager = get_node("/root/Main/RoomManager")


signal request_input(prompt)


func interact():
	var prompt = Prompt.new()
	prompt.prompt = "Enter command: reset_router"
	prompt.response = "reset_router"
	emit_signal("request_input", prompt)


func handle_input_complete(status) -> void:
	self.roomManager.set_wifi_level(self.roomManager.wifi_level + 20)
