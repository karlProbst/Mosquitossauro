extends Node2D
var arrayOfMosquitos=[]
var spawner = Spawner.new()
@onready var mosquito:PackedScene=preload("res://mosquitolho.tscn")
var maxmosquitos=50
var spawnTimer =0
func _ready() -> void:
	spawnMosquito(3)
func addofsettoCamera(delta):
	if $UICanvasLayer.visible:
		var camera = get_node("Camera2D")
		var oset=get_global_mouse_position()/25
		#oset+=Vector2(1280/2,+720/2)
		camera.position.x=552+oset.x
		camera.position.y=236+oset.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	addofsettoCamera(_delta)
	if maxmosquitos>0:
		if spawnTimer<=0:
			spawnMosquito(3)
			spawnTimer=5.0
			maxmosquitos-=3
		spawnTimer-=_delta
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_accept"):
		changeSceneToRoom()
	if Input.is_action_pressed("spawnMosquitao"):
		spawnMosquito(1)
func changeSceneToRoom():
	get_tree().change_scene_to_packed(preload("res://Scenes/Stages/lightScene.tscn"))

		
func spawnMosquito(n:int= 1):

	for i in range(n):
		var instMosquito = spawner.Instantiate(mosquito,Vector2(randi_range(0,500),randi_range(0,600)),self)
		instMosquito.fly_speed = 250.0+randi_range(0,200)
		instMosquito.agressivness=3
		instMosquito.scale.x=0.12+randf()/5
		instMosquito.scale.y=instMosquito.scale.x
		instMosquito.connect("justDied",Callable(self,"_on_just_died"))
		arrayOfMosquitos.append(instMosquito)
		

func killAllMosquitoes():
	for mi in arrayOfMosquitos:
		if mi:
			mi.queue_free()
