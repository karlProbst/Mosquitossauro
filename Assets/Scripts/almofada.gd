extends RigidBody2D


@export var player:Node2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isGrabbed=false
var lockchute=false
const friction=500
func _physics_process(delta: float) -> void:
	if player.chutando>0 and not lockchute:
		
		if is_colliding_with_chute($CollisionShape2D/R1):
			var player_velocity_x = player.velocity.x
			var maxplayerspeed=player.max_speed.x # Assuming player.velocity.x is the value to remap
			var remapped_velocity_x = remap(player_velocity_x, -maxplayerspeed, maxplayerspeed, -1.2, 1.2)
			
			throw(Vector2(remapped_velocity_x,-1), 1200)
			lockchute=true
	if player.chutando==0:
		lockchute=false
		


func throw(dir:Vector2, amp:float) -> void:
	if dir:
		apply_impulse(dir*amp,Vector2.ZERO)

		
func is_colliding_with_chute(raycast: RayCast2D) -> bool:
	if raycast:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.is_in_group("chute"):
				return true
	return false
