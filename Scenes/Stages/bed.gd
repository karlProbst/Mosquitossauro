extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player=  GlobalSingleton.getPlayer().get_node("Skeleton2D/Hip")
	if player:
		if player.global_position.y<global_position.y-125:
			self.set_collision_layer_value(6,1)
		else:		
			self.set_collision_layer_value(6,0)
