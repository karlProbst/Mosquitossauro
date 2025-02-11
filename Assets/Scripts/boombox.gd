extends CharacterBody2D

@export var player:Node2D
const SPEED = 60.0
const JUMP_VELOCITY = 300.0
var isGrabbed=false
var lockchute=false
const friction=1200
var health = 5
func _physics_process(delta: float) -> void:
	if player.chutando>0 and not lockchute:
		
		if is_colliding_with_chute($CollisionShape2D/R1):
			
			var player_velocity_x = player.velocity.x
			var maxplayerspeed=player.max_speed.x # Assuming player.velocity.x is the value to remap
			var remapped_velocity_x = remap(player_velocity_x, -maxplayerspeed, maxplayerspeed, -1.2, 1.2)
			
			throw(Vector2(remapped_velocity_x,-1), JUMP_VELOCITY)
			take_damage()
			lockchute=true
	if player.chutando==0:
		lockchute=false
	if get_node_or_null("TrapMoskitao"):
		if $TrapMoskitao.pitch_scale<1:
			$TrapMoskitao.pitch_scale+=delta/2
	if not isGrabbed:
		if not is_on_floor():
			velocity += get_gravity() * delta
			velocity.x = move_toward(velocity.x, 0, friction * delta/4)	
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		move_and_slide()
	if position.y>595 and health>0:
		$Pa.play()
		take_damage(2)
func throw(dir:Vector2, amp:float) -> void:
	if dir:
		velocity=dir*amp
	else:
		velocity.y = amp
func take_damage(damage:int=1) -> void:
	$Pa.play()
	if health<=0:
		return
	
	health -= damage
	if health==4:
		$TrapMoskitao.pitch_scale=0.7
	if health==3:
		$TrapMoskitao.pitch_scale=0.6
	if health==2:
		$TrapMoskitao.pitch_scale=0.5	
	if health==1:
		$TrapMoskitao.pitch_scale=0.4

	for h in range(1, 6):  
		var node = get_node_or_null("B"+str(h)) 
		if node:
			node.visible = (h == health) 
	if health<=0:
		$B1.visible=true
		$TrapMoskitao.queue_free()
			
func is_colliding_with_chute(raycast: RayCast2D) -> bool:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("chute"):
			return true
	return false
	
