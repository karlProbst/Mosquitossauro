extends Node2D

@onready var mosquito:PackedScene=preload("res://mosquitolho.tscn")
var mosquitoskilled = 0
var spawner=Spawner.new()
var arrayOfMosquitos=[]
var spawnedN:int=0
var spawnTimer=30
var stage= "killNMosquitoes"
var stageProgress="start"
var stage1MaxKills=30
var lockUpdateObjective=false

func _ready() -> void:
	spawnMosquito(10)
	GlobalSingleton.player=$OldMan
	GlobalSingleton.camera=$Camera2D
	


func _process(_delta: float) -> void:
	if stage=="killNMosquitoes":
		
		if stageProgress=="start":
			if not lockUpdateObjective and spawnTimer<29:
				get_node("UICanvasLayer").updateObjective("The swarm is relentless... Defeat 30 mosquitoes to survive!")
				lockUpdateObjective=true
			if spawnTimer<=0:
				spawnMosquito(8)
				spawnTimer=8.0
			spawnTimer-=_delta
			if GlobalSingleton.killed>=stage1MaxKills:
				get_node("UICanvasLayer").updateObjective("I need water, got to the kitchen")
				stageProgress="done"
		if stageProgress=="done":
			var doorh = get_node("AreaCena/Door/Highlight")
			if GlobalSingleton.getPlayer().global_position.x<-1300:
				doorh.visible=true
				if Input.is_action_just_pressed("interact"):
					stageProgress="transition"
			else:
				doorh.visible=false
			
		if stageProgress=="transition":
			$Camera2D.toNextStage=true
			if $Camera2D/ColorRect.modulate.a>=1:
				GlobalSingleton.setStoredItem(GlobalSingleton.getPlayer().currentItem)
				get_tree().change_scene_to_packed(preload("res://Scenes/Kitchen.tscn"))
	if Input.is_action_pressed("spawnMosquitao"):
		spawnMosquito(1)
	if Input.is_action_pressed("restart"):
		GlobalSingleton.deadPlayer()
	if Input.is_action_pressed("killall"):
		killAllMosquitoes()
func killMosquito():
	mosquitoskilled+=1
	GlobalSingleton.add_kill()
func spawnMosquito(n:int= 1):
	
	if spawnedN<50:
		for i in range(n):
			var instMosquito = spawner.Instantiate(mosquito,Vector2(randi_range(-500,600),randi_range(150,600)),self)
			instMosquito.fly_speed = 300.0+randi_range(0,200)
			
			instMosquito.scale.x=0.45+randf()/2
			instMosquito.scale.y=instMosquito.scale.x
			instMosquito.connect("justDied",Callable(self,"_on_just_died"))
			arrayOfMosquitos.append(instMosquito)
			spawnedN+=1
func _on_just_died():
	spawnedN-=1
func killAllMosquitoes():
	if spawnedN>0:
		for mi in arrayOfMosquitos:
			
			if is_instance_valid(mi):
				mi.queue_free()
				mi=null
				spawnedN-=1
