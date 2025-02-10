extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$OldMan/RHand.global_position = get_global_mouse_position()


func _on_button_button_down() -> void:
	$AnimationPlayer.play("LightsOn")
	
func changeSceneToRoom():
	get_tree().change_scene_to_packed(preload("res://Scenes/Stages/room.tscn"))
