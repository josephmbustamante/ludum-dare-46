extends Node2D


signal wifi_level_changed(new_wifi_level)


export (int, 0, 100) var wifi_level: int = 100 setget set_wifi_level


onready var room_manager_tick_timer = $RoomManagerTickTimer


func _ready() -> void:
	room_manager_tick_timer.start()


func set_wifi_level(new_wifi_level):
	print("setting wifi level!")
	var potential_new_wifi_level = clamp(new_wifi_level, 0 ,100)
	if potential_new_wifi_level != wifi_level:
		wifi_level = potential_new_wifi_level
		emit_signal("wifi_level_changed", wifi_level)


func _on_RoomManagerTickTimer_timeout() -> void:
	set_wifi_level(wifi_level - 1)
