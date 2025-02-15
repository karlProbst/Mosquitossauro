extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interactible_controller_class_destroyed() -> void:
	if $CollisionShape2D:
		$CollisionShape2D.queue_free()
	var parent = get_parent()
	if parent.has_method("spawnMosquito"):
		parent.spawnMosquito(5)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("chute") or area.is_in_group("almofada"):
		$InteractibleControllerClass.takeDamage(1)
