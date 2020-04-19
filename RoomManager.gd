extends Node2D
class_name RoomManager

onready var room_manager_tick_timer = $RoomManagerTickTimer
var router: Router = null

func _ready() -> void:
	room_manager_tick_timer.start()

func set_router(new_router: Router):
	router = new_router

func _on_RoomManagerTickTimer_timeout() -> void:
	router.set_wifi_level(router.wifi_level - 1)
