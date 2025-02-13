extends Node2D
class_name PlatformControllerClass
func ready():
	get_parent().set_collision_layer(1,0)
	get_parent().set_collision_mask_value(6,1)
func _process(delta: float) -> void:
	var player =  GlobalSingleton.getPlayer().get_node("Skeleton2D/Hip")
	if player:
		if player.global_position.y<get_parent().global_position.y-80:
			get_parent().set_collision_layer_value(6,1)
			
		else:	
			get_parent().set_collision_layer_value(6,0)
