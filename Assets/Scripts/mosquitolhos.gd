extends Node2D

@export var fly_speed: float = 300.0  # Speed of mosquito flying
@export var circle_radius: float = 100.0  # Radius of circular motion
@onready var player:Node2D = get_parent().get_node("OldMan")

@export var velocity_threshold: float = 50.0  # Threshold for player's velocity
@export var inactivity_time: float = 3.0  # Time before the mosquito stops moving
var velocity = Vector2.ZERO
var wallSpace:Vector4 = Vector4i(-1000,140,800,600)
# Internal variables
var time_passed: float = 0.0

var target_position: Vector2=Vector2.ZERO
var is_resting = false
var inactivity_timer_max:float=2.0
var inactivity_timer: float = inactivity_timer_max
var random_movement_timer_max: float = 0.3
var random_movement_timer: float = random_movement_timer_max
var mouse_movement_threshold = 50
var previous_mouse_position = Vector2.ZERO
# Animation player
#@onready var splash = $Splash
var cena =preload("res://Scenes/Sparkle.tscn")
var blood =preload("res://Scenes/Blood.tscn")
var gothit=0.0
var gothit_max=0.1

var health=5
var lockdead=false

var spawner = Spawner.new()
func _ready() -> void:
	target_position = global_position  # Set initial target position
 # Start with the flying animation
func got_hit(damage):
	
	gothit=gothit_max
	health-=damage
	velocity += (global_position - player.global_position).normalized()*100
	rotation+=30
	player.hitTest(position)
	
		#spawner.DeleteOnFinished(novacena.get_child(0))
func _process(delta: float) -> void:
	

	if position.y<wallSpace.y:
		position.y=wallSpace.y
	if health>0:
		if $Rleft.is_colliding():
			if velocity.x<0:
				velocity.x*=-1.3
				position.x+=1

		if $Rright.is_colliding():
			if velocity.x>0:
				velocity.x*=-1.3
				position.x-=1

		if $Rup.is_colliding():
			if velocity.y<0:
				velocity.y*=-1.3
				position.y+=1

		if $Rdown.is_colliding():
			if velocity.y>0:
				velocity.y*=-1.3
				position.x-=5

	if health<=0:
		if not lockdead:
			get_parent().mosquitoskilled+=1
			lockdead=true
		if $Rdown.is_colliding():
			if $Rdown.get_collider().is_in_group("Player"):
				position.y+=delta*100
		else:
			position.y+=delta*100
			
	var ray = $RayCast2D
	ray.force_raycast_update()
	if ray.is_colliding():
		
		var col = ray.get_collider()
		if col.is_in_group("player") and health>0:
			var bloodcena = spawner.Instantiate(blood,global_position,get_parent())
			spawner.InjectArgs(bloodcena,{"emitting": "true"})
			print("bloooood")
			
		if col.is_in_group("almofada"):
			velocity=col.velocity
		if col.is_in_group("almofada") and position.y<150:
			queue_free()
		if col.is_in_group("raquete"):
			
			$Polygon2D.modulate = Color(0, 0, 0, 1) 
			if health>0:
				
				var novacena = spawner.Instantiate(cena,global_position,get_parent())
				spawner.InjectArgs(novacena,{"emitting": "true"})
				
			got_hit(10)
			
			
				
		if col.is_in_group("veneno"):
			fly_speed/=1.2
			if gothit<=0:
				got_hit(1) 
	if gothit>0:
		gothit-=delta	
	
	
	#SE TIVER VIVO
	if health>0:
		if rotation>0:
			rotation=lerpf(rotation,0,delta*10)
		if not is_resting or gothit>0:
			time_passed += delta
			#target_position = global_position + Vector2(
			#	cos(time_passed) * circle_radius,
			#	sin(time_passed) * circle_radius
			#)
			move_toward_target(delta)
		
		# React to player movement
		if player:
			if abs(player.velocity.x) > velocity_threshold or abs(player.velocity.y) > velocity_threshold:
				go_to_ceiling()

		# Handle inactivity logic
		
			if abs(player.velocity.x) < 10 and abs(player.velocity.y) < 10 and not is_resting:
				inactivity_timer += delta
				if inactivity_timer >= inactivity_timer_max:
					go_to_rest()
				
			else:
				is_resting=false
				inactivity_timer = 0.0  # Reset the timer if the player moves

		var current_mouse_position = get_global_mouse_position()

		# Calculate the distance moved
		var distance_moved = previous_mouse_position.distance_to(current_mouse_position)

		# Trigger the event if the distance exceeds the threshold
		if distance_moved > mouse_movement_threshold:
			go_to_ceiling()

		# Update the previous mouse position
		previous_mouse_position = current_mouse_position
	
		
		
func move_toward_target(delta: float) -> void:
	# Compute the desired direction
	var direction = (target_position - global_position).normalized()
	random_movement_timer-=delta
	if random_movement_timer<=0:
		velocity+=Vector2(randi_range(-130,130),randi_range(-130,130))
		random_movement_timer=randf_range(0,random_movement_timer_max)
	# Interpolate velocity for smoother turning
	velocity = velocity.lerp(direction * fly_speed, delta * 4)  # Smooth turning
	
	# Update global position
	global_position += velocity * delta
	
	

func go_to_ceiling() -> void:
	target_position = Vector2(randi_range(wallSpace.x,wallSpace.z), wallSpace.y+randi_range(0,50))  # Go to the ceiling
	move_toward_target(get_process_delta_time())

func go_to_rest() -> void:
	
	is_resting = true
	 # Change to resting animation
	target_position = Vector2(
		randi_range(wallSpace.x,wallSpace.z),
		randi_range(wallSpace.y,wallSpace.w)
	)
	inactivity_timer_max=randf_range(0.5, 3.0)


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
