extends CharacterBody2D

@onready var player:Node2D = get_parent().get_node("OldMan")
var lockchute=false
const friction=500

const JUMP_VELOCITY = -400.0
@export var item="spray"
var highlight=0
var highlightitem
	
			
func _ready() -> void:
	updateItem()
func _physics_process(delta: float) -> void:
	
	if highlight>0:
		if highlightitem==null:
			for c in get_children():
				if c.visible:
					highlightitem=c.get_node("highlight")
					highlightitem.visible=true
	elif highlightitem:
		highlightitem.visible=false
		highlightitem=null
		highlight = 0
	if highlight>0:
		highlight-=delta*10
	rotation_degrees+=velocity.x*delta
	if player.chutando>0 and not lockchute:
		if is_colliding_with_chute($RayCast2D):
			var player_velocity_x = player.velocity.x
			var maxplayerspeed=player.max_speed.x # Assuming player.velocity.x is the value to remap
			var remapped_velocity_x = remap(player_velocity_x, -maxplayerspeed, maxplayerspeed, -1.2, 1.2)
			
			throw(Vector2(remapped_velocity_x,-1), 1200)
			lockchute=true
	if player.chutando==0:
		lockchute=false
		

	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0, friction * delta/4)	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_slide()
	
	
	
func updateItem():
	remove_from_group("raquete")
	for c in get_children():
		c.visible=false
	match item:
		"none":
			queue_free()
			# Add logic for no item
		"spray":
			$Sbp.visible=true
			
			# Add logic for spray
		"raquete":
			add_to_group("raquete")
			$Raqueteleletrica.visible=true
			# Add logic for raquete
		"box":
			print("Current item is a water cup.")
			# Add logic for water cup
		"awp":
			print("Current item is an AWP.")
			# Add logic for AWP
		_:
			queue_free()
			# Handle unknown items
	return
	
func throw(dir:Vector2, amp:float) -> void:
	if dir:
		velocity=dir*amp
	else:
		velocity.y = amp
		
func is_colliding_with_chute(raycast: RayCast2D) -> bool:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("chute"):
			return true
	return false
