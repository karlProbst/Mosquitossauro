extends Node2D

@onready var mosquito:PackedScene=preload("res://mosquitolho.tscn")
var mosquitoskilled = 0
var spawner=Spawner.new()
var arrayOfMosquitos=[]
var spawnedN:int=0
var spawnTimer=30
var stage= "killNMosquitoes"
var stageProgress = "start"
func _ready() -> void:
	spawnMosquito(7)
	GlobalSingleton.player=$OldMan
	GlobalSingleton.camera=$Camera2D
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if stage=="killNMosquitoes":
		if spawnTimer<=0:
			spawnMosquito(15)
			spawnTimer=17.5
		spawnTimer-=_delta
		if stageProgress=="transition":
			if GlobalSingleton.killed>=60:
				$Camera2D.toNextStage=true
				if $Camera2D/ColorRect.modulate.a>=1:
					get_tree().change_scene_to_packed(preload("res://Scenes/Stages/MeditatingScene.tscn"))
	if Input.is_action_pressed("spawnMosquitao"):
		spawnMosquito(1)
func killMosquito():
	mosquitoskilled+=1
	GlobalSingleton.add_kill()
func spawnMosquito(n:int= 1):
	if spawnedN<50:
		for i in range(n):
			var instMosquito = spawner.Instantiate(mosquito,Vector2(randi_range(-500,600),randi_range(150,600)),self)
			instMosquito.fly_speed = 400.0+randi_range(0,200)
			instMosquito.scale.x=0.75+randf()/2
			instMosquito.scale.y=instMosquito.scale.x
			instMosquito.updateBounds()
			arrayOfMosquitos.append(instMosquito)
			spawnedN+=1
			instMosquito.connect("justDied",Callable(self,"_on_just_died"))
		
func _on_just_died():
	spawnedN-=1
