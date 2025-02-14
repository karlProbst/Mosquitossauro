extends RigidBody2D

@onready var interactible_controller = $InteractibleControllerClass
var player
var lockchute = false
var item = "raquete"
var spawner=Spawner.new()
func _ready() -> void:
	player=GlobalSingleton.getPlayer()
func _process(_delta: float) -> void:
	if global_position.y>5000:
		queue_free()
	if player:
		if player.chutando==0:
			lockchute=false
	else:
		player=GlobalSingleton.getPlayer()	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("chute"):
		interactible_controller.takeDamage()
		if not lockchute:
			var player_velocity_x = player.velocity.x
			var maxplayerspeed=player.max_speed.x 
			var remapped_velocity_x = remap(player_velocity_x, -maxplayerspeed, maxplayerspeed, -0.8, 0.8)
			apply_central_impulse(Vector2(remapped_velocity_x,-1)*350)
			var rotation_impulse = player_velocity_x * 10  # Scale by X velocity (adjust multiplier for desired effect)
			apply_torque_impulse(rotation_impulse)
			lockchute=true

func spawnItem():
	var itemScene=preload("res://Scenes/generic_item.tscn")
	var instance = spawner.Instantiate(itemScene,position,get_parent())
	spawner.InjectArgs(instance,{"item":item,"velocity":linear_velocity})
	instance.updateItem()

func _on_interactible_controller_class_destroyed() -> void:
	spawnItem()
