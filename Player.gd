extends KinematicBody2D

signal player_interacted_with_object()
signal player_can_interact_with_object(object)
signal player_cannot_interact_with_object(object)
signal player_stress_level_changed(new_stress_level)


export (int) var speed = 100


onready var stress_tick_timer = $StressTickTimer
onready var animation_player = $AnimationPlayer


var stress_level: int = 0 setget set_stress_level
var movement_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	start_stress_timer()


func _physics_process(delta: float) -> void:
	if movement_direction != Vector2.ZERO:
		animation_player.play("walk")
		# if stress level is 0 (or, no stress), just use actual speed
		var actual_speed: float = speed

		# if our stress level is 100, move at 20% speed
		if stress_level == 100:
			actual_speed = 20

		# if our stress level is between 0 and 100, move at a variable rate between 20% and 100%
		elif stress_level > 0:
			var modifier: float = 80 * ((stress_level as float) / 100)
			actual_speed = speed - modifier

		move_and_slide(movement_direction.normalized() * actual_speed)
	else:
		animation_player.stop(true)


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


func start_stress_timer():
	stress_tick_timer.start()


func stop_stress_timer():
	stress_tick_timer.stop()


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
	set_stress_level(stress_level + 4)
