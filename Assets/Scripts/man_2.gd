extends Node2D

@export var MaoTarget: Node2D
@export var Hip: Node2D
@export var AnimPlayer: Node2D
@export var max_speed: Vector2 = Vector2(200, 120)
@export var acceleration: float = 1200.0  # Rate of acceleration
@export var friction: float = 1000.0      # Rate of deceleration

# Store the input direction and velocity
var input_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Update MaoTarget position to follow the mouse
	MaoTarget.global_position = get_global_mouse_position()

	# Reset input direction each frame
	input_direction = Vector2.ZERO

	# Capture movement input
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1

	# Normalize input direction to prevent faster diagonal movement
	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()
		# Apply acceleration
		velocity += input_direction * acceleration * delta
	else:
		# Apply friction when no input is detected
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Clamp velocity to max_speed
	velocity.x = clamp(velocity.x, -max_speed.x, max_speed.x)
	velocity.y = clamp(velocity.y, -max_speed.y, max_speed.y)

	# Update Hip position
	
	Hip.global_position += velocity * delta
	AnimPlayer.position=Hip.position
