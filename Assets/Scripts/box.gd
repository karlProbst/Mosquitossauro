extends RigidBody2D


const JUMP_VELOCITY = -400.0
var lockchute = false
var health = 6
var cudown =0
var spawner = Spawner.new()
@onready var player:Node2D = get_parent().get_node("OldMan")
var item="raquete"
func _ready() -> void:
	if player==null:
		player=get_node("OldMan")
func _physics_process(delta: float) -> void:

	if player:
		if player.chutando>0 and not lockchute:

			if $Node2D/Ray1.is_colliding() or $Node2D/Ray2.is_colliding() :
				var player_velocity_x = player.velocity.x
				var maxplayerspeed=player.max_speed.x
				var remapped_velocity_x = remap(player_velocity_x, -maxplayerspeed, maxplayerspeed, -1.2, 1.2)
				
				apply_central_impulse(Vector2(remapped_velocity_x,-1)*2000)
				lockchute=true
		if player.chutando==0:
			lockchute=false
		if cudown<=0:
			if linear_velocity.length() * mass>5:
				if $Node2D/Ray1.is_colliding() or $Node2D/Ray2.is_colliding() :
					take_damage()
					cudown=0.01
		else:
			cudown-=delta
func spawnItem():
	var itemScene=preload("res://Scenes/generic_item.tscn")
	var instance = spawner.Instantiate(itemScene,position,get_parent())
	spawner.InjectArgs(instance,{"item":item,"velocity":linear_velocity})
	instance.updateItem()
func take_damage(damage:int=1) -> void:

	health -= damage
	if health <= 0:
		spawnItem()
		queue_free()

	for h in range(1, 7):  # Loop through nodes "1" to "5"
		var node = get_node_or_null("B"+str(h))  # Get the node by name	
		if node:
			node.visible = (h == health) 
func is_colliding_with_chute(raycast: RayCast2D) -> String:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("chute"):
			return raycast.name
	return "none"
