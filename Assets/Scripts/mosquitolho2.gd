extends Node2D

var fly_speed: float = 450.0+randi_range(0,500) # Speed of mosquito flying

@onready var player:Node2D = get_parent().get_node("OldMan")


var velocity = Vector2.ZERO
var wallSpace:Vector4 = Vector4(-1229,-6,849-50,626)
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

var gothit=0.0
var gothit_max=0.1
const MAX_HEALTH=8
var health=MAX_HEALTH

var lockdead=false
var byting=0
var spawner = Spawner.new()
var stuck=false
var bytingMax=10.0
var bytingCharge=4.0
var agressivness = 1.0-randf_range(0.01,0.2)
var cellingRounds=0
var laserPointTo
var laserPointToPlayer
var deadTimer:float=0

signal justDied

func _ready() -> void:
	var bounds = get_parent().get_node_or_null("Bounds")
	if bounds:
		wallSpace.x=bounds.get_point_position(0).x
		wallSpace.y=bounds.get_point_position(0).y
		wallSpace.z=bounds.get_point_position(2).x
		wallSpace.w=bounds.get_point_position(2).y
	target_position = global_position  
	scale.x=0.65+randf()
	scale.y=scale.x
func got_hit(damage):
	gothit=gothit_max
	health-=damage
	velocity += (global_position - player.global_position).normalized()*100
	rotation_degrees+=90
	player.hitTest(position)
	if health<0:
		health=0
func _process(delta: float) -> void:
	
	
	$Polygon2D.skew=velocity.x/(fly_speed*1.3)
	$Polygon2D.scale.y=1+abs(velocity.y/(fly_speed*2.1))
	$Polygon2D.scale.x=1-abs(velocity.y/(fly_speed*2.3))
		
	if health>0:
		if $Rleft.is_colliding():
			if velocity.x<0:
				velocity.x*=-1.3
				position.x+=1
				byting=0
		if $Rright.is_colliding():
			if velocity.x>0:
				velocity.x*=-1.3
				position.x-=1
				byting=0
		if $Rup.is_colliding():
			if velocity.y<0:
				velocity.y*=-1.3
				position.y+=1
				byting=0
		if $Rdown.is_colliding():
			if velocity.y>0:
				velocity.y*=-1.3
				position.x-=5
				byting=0
	if health<=0:
		
		if not lockdead:
			get_parent().killMosquito()
			lockdead=true
		if not stuck:
			if $Rdown.is_colliding():
				if $Rdown.get_collider():
					if $Rdown.get_collider().is_in_group("Player"):
						position.y+=delta*100
			else:
				position.y+=delta*100
			
	
	#SE TIVER VIVO

	if health>0:
		if rotation>0 and gothit<=0:
			rotation=lerpf(rotation,0,delta*10)
		var ray = $RayCast2D
		ray.force_raycast_update()
		if ray.is_colliding():
	
			var col = ray.get_collider()
			if col.is_in_group("chute"):
				velocity=Vector2(10000,-10000)
			
				
			if col.is_in_group("almofada"):
				velocity=col.linear_velocity
			if col.is_in_group("almofada") and position.y<wallSpace.y+50:
				got_hit(20)
				stuck=true
				position.y=wallSpace.y
			if col.is_in_group("raquete"):
				$Polygon2D.modulate = Color(0, 0, 0, 1) 
				if health>0:
					var novacena = spawner.Instantiate(cena,global_position,get_parent())
					spawner.InjectArgs(novacena,{"emitting": "true"})	
					got_hit(20)	
			if col.is_in_group("veneno"):			
				if gothit<=0:
					byting=0
					got_hit(1) 
		if gothit>0:
			gothit-=delta	
			
		if  gothit<=0:
			move_toward_target(delta)

		if inactivity_timer<=0 and byting<=0:
			var rand=randf()
			
			if rand<(0.1+(MAX_HEALTH-health)/10):
				cellingRounds=20
				
			if rand>agressivness:
				if player:
					go_byte()
					cellingRounds=0
			elif byting<=0 and cellingRounds<=0:
				go_wild()
			if cellingRounds>0:
				go_to_ceilling()
				cellingRounds-=1
				
		if inactivity_timer>0:
			inactivity_timer-=delta
		if byting>0:
			$RayLaser.enabled=true
			byting-=delta
			var rayLaser=$RayLaser
			$RayLaser/Line2D.set_point_position(1, $RayLaser/Line2D.to_local(target_position))
			rayLaser.target_position=rayLaser.to_local(target_position)
			if rayLaser.is_colliding():
				if rayLaser.get_collider().is_in_group("player"):
					laserPointToPlayer= rayLaser.get_collision_point()
				laserPointTo= rayLaser.get_collision_point()
				$RayLaser/Line2D.set_point_position(1, $RayLaser/Line2D.to_local(laserPointTo))
				
		else:
			$RayLaser.enabled=false
			byting=0
			$RayLaser/Line2D.set_point_position(1,Vector2.ZERO)
	#DEAD
	else:
		
		$RayLaser.enabled=false
		$RayLaser/Line2D.set_point_position(1,Vector2.ZERO)
		byting=0
		deadTimer+=delta
		
		if deadTimer>=30:
			queue_free()
			emit_signal("justDied")
		
	velocity.x=clampf(velocity.x,-fly_speed*1.5,fly_speed*1.5)
	velocity.y=clampf(velocity.y,-fly_speed*1.5,fly_speed*1.5)	
	if position.y<wallSpace.y:
		position.y=wallSpace.y+5
	if position.y>wallSpace.w:
		position.y=wallSpace.w-5
	if position.x<wallSpace.x:
		position.x=wallSpace.x+5
	if position.x>wallSpace.z:
		position.x=wallSpace.z-5
func move_toward_target(delta: float) -> void:
	# Compute the desired direction
	var direction = (target_position - global_position).normalized()

	if random_movement_timer<=0:
		velocity+=Vector2(randi_range(-130,130),randi_range(-130,130))
		random_movement_timer=randf_range(0,random_movement_timer_max)
	# Interpolate velocity for smoother turning
	velocity = velocity.lerp(direction * fly_speed, delta * 4)  # Smooth turning
	
	if byting>0:
		random_movement_timer=0.1
	if byting>0 and byting<(bytingMax-bytingCharge):
		global_position += velocity * delta*1.8	
		
	else:
		random_movement_timer-=delta
		global_position += velocity * delta
		
func go_to_ceilling():
	target_position=Vector2(randf_range(wallSpace.x,wallSpace.z),wallSpace.y+randi_range(0,50))		
	var distance = target_position.distance_to(global_position)
	var timeItTakes = distance/fly_speed
	inactivity_timer_max=timeItTakes+randf()
	inactivity_timer=inactivity_timer_max
func go_to_light() -> void:
	target_position = Vector2(randf_range(wallSpace.x/4,wallSpace.z/4), wallSpace.y+randi_range(0,50))  # Go to the ceiling

	
func go_byte():
	byting=bytingMax
	var player_position = player.get_node("CollisionChest").global_position

	# Calculate the angle to the player
	var angle_to_player = (player_position - global_position).angle()

	# Extrapolate a target position from the angle
	var distance = 2500  # Adjust this for how far the line should go
	target_position = global_position + Vector2(cos(angle_to_player), sin(angle_to_player)) * distance


	#var target_position = collision_chest.global_position + direction * 100 
func go_wild() -> void:

	target_position = Vector2(
		randf_range(wallSpace.x,wallSpace.z),
		randf_range(wallSpace.y,wallSpace.w)
	)
	var distance = target_position.distance_to(global_position)
	var timeItTakes = distance/fly_speed
	inactivity_timer_max=timeItTakes+randf()
	inactivity_timer=inactivity_timer_max


func _on_body_entered(body: Node2D) -> void:
	if body:
		if body.is_in_group("player") and health>0 and byting>0:
			if player:
				player.gotHit(1,laserPointToPlayer)
			byting=0
		if health<=0:
			deadTimer+=30.0	
