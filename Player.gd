extends KinematicBody2D

signal player_interacted_with_object()
signal player_can_interact_with_object(object)
signal player_cannot_interact_with_object(object)
signal player_stress_level_changed(new_stress_level)


export (int) var speed = 100


onready var stress_tick_timer = $StressTickTimer


var stress_level: int = 100 setget set_stress_level
var movement_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	stress_tick_timer.start()


func _physics_process(delta: float) -> void:
	if movement_direction != Vector2.ZERO:
		move_and_slide(movement_direction.normalized() * speed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		emit_signal("player_interacted_with_object")

	if event.is_action_pressed("down"):
		movement_direction.y += 1
	if event.is_action_pressed("up"):
		movement_direction.y += -1
	if event.is_action_pressed("left"):
		movement_direction.x += -1
	if event.is_action_pressed("right"):
		movement_direction.x += 1

	if event.is_action_released("down"):
		movement_direction.y -= 1
	if event.is_action_released("up"):
		movement_direction.y -= -1
	if event.is_action_released("left"):
		movement_direction.x -= -1
	if event.is_action_released("right"):
		movement_direction.x -= 1


func set_stress_level(new_stress_level: int):
	var actual_new_stress_level = clamp(new_stress_level, 0, 100)
	stress_level = actual_new_stress_level
	emit_signal("player_stress_level_changed", stress_level)


func _on_ObjectInteractionRadius_body_entered(body: Node) -> void:
	if body.has_method("interact"):
		emit_signal("player_can_interact_with_object", body)


func _on_ObjectInteractionRadius_body_exited(body: Node) -> void:
	if body.has_method("interact"):
		emit_signal("player_cannot_interact_with_object", body)


func _on_StressTickTimer_timeout() -> void:
	set_stress_level(stress_level - 1)
