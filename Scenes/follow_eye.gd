extends Node2D
var player
@onready var eye = $Eye
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		player=GlobalSingleton.getPlayer().get_node("Body/Head")
	else:
		eye.look_at(player.global_position)
