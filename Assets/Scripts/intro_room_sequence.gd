extends Node2D

@onready var mosquito:PackedScene=preload("res://mosquitolho.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_accept"):
		changeSceneToRoom()
	if Input.is_action_pressed("spawnMosquitao"):
		spawnMosquito(1)
func changeSceneToRoom():
	get_tree().change_scene_to_packed(preload("res://Scenes/Stages/lightScene.tscn"))
func spawnMosquito(n:int = 3):
	for i in range(n):
		var instance = mosquito.instantiate()
		instance.global_position = Vector2(800,200)+Vector2(randi_range(-5,60),randi_range(15,60))
		instance.script = preload("res://Assets/Scripts/mosquitolhos.gd")
		
