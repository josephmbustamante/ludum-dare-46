extends StaticBody2D


export (GlobalEnums.ObjectTypes) var object_type = GlobalEnums.ObjectTypes.BED


signal request_input(prompt)


onready var stress_restore_tick_timer = $StressRestoreTickTimer


var player = null


func set_player(player):
	self.player = player


func interact():
	if player == null:
		return

	var prompt = Prompt.new()
	prompt.prompt = "You are sleeping. Type \"wake up\" to stop."
	prompt.response = "wake up"
	player.stop_stress_timer()
	stress_restore_tick_timer.start()
	emit_signal("request_input", prompt)


func handle_input_complete(status) -> void:
	player.start_stress_timer()
	stress_restore_tick_timer.stop()


func _on_StressRestoreTickTimer_timeout() -> void:
	if player != null:
		player.stress_level -= 5
