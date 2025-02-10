extends Node2D

@onready var mosquito:PackedScene=preload("res://mosquitolho.tscn")
var mosquitoskilled = 0
var spawner=Spawner.new()
var arrayOfMosquitos=[]
func _ready() -> void:
	spawnMosquito(15)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("spawnMosquitao"):

		spawnMosquito(1)
func killMosquito():
	mosquitoskilled+=1
	GlobalSingleton.add_kill()
func spawnMosquito(n:int= 1):
	for i in range(n):
		var instMosquito = spawner.Instantiate(mosquito,Vector2(randi_range(-500,600),randi_range(150,600)),self)
		arrayOfMosquitos.append(instMosquito)
