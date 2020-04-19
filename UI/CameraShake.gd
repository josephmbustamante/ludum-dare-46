extends Camera2D

# exported parameters
export var speed: float = 1.0
export var decay_rate: float = 0.5
#export var max_yaw := 0.05
#export var max_pitch := 0.05
export var max_roll: float = 20.0
export var max_offset: float = 40.0
#export var max_roll := 0.1
#export var max_offset := 0.2

# default values
onready var start_position := position
onready var start_rotation := rotation
var trauma: float = 0.0
var time: float = 0.0
var noise := OpenSimplexNoise.new()
var noise_seed := randi()


# configure noise
func _init() -> void:
	noise.seed = noise_seed
	noise.octaves = 1
	noise.period = 256.0
	noise.persistence = 0.5
	noise.lacunarity = 1.0


# apply shake if there's any trauma
func _process(delta: float) -> void:
	if trauma > 0.0:
		decay_trauma(delta)
		apply_shake(delta)


# add trauma to start/continue the shake
func add_trauma() -> void:
	trauma = 0.2


# decay the trauma effect over time
func decay_trauma(delta: float) -> void:
	var change := decay_rate * delta
	trauma = max(trauma - change, 0.0)


# apply shake to starting camera position
func apply_shake(delta: float) -> void:
	# using a magic number here to get a pleasing effect at speed 1.0
	time += delta * speed * 5000.0
	var shake: float = trauma * trauma
	#var yaw := max_yaw * shake * get_noise_value(noise_seed, time)
	#var pitch := max_pitch * shake * get_noise_value(noise_seed + 1, time)
	var roll: float = max_roll * shake * get_noise_value(noise_seed + 2, time)
	var offset_x: float = max_offset * shake * get_noise_value(noise_seed + 3, time)
	var offset_y: float = max_offset * shake * get_noise_value(noise_seed + 4, time)
	position = start_position + Vector2(offset_x, offset_y)
#	rotation = start_rotation + Vector3(pitch, yaw, roll)
	rotation = start_rotation + roll


# return a random float in range(-1, 1) using OpenSimplex noise
func get_noise_value(seed_value: int, time: int) -> float:
	noise.seed = seed_value
	return noise.get_noise_2d(time, time)
