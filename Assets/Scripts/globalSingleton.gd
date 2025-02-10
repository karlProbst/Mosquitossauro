extends Node

var health
var killed

var player:Node2D
var camera:Node
func _ready():
	
	health = 3
	killed = 0
		
func getPlayer():
	if player:
		if player.has_method("updateItemOnHand"):
			return player
		
func getCamera():
	if camera:
		if camera.has_method("_process"):
			return camera
		
func remove_hearts(count:int)->void:
	health-=count
	if health<=0:
		health = 0
		dyingPlayer()
	var ui =  get_tree().root.get_node("Room/UICanvasLayer")
	if ui:
		ui.updateHealth(health)
func add_kill(n:int=1):
	killed+=n

	var ui =  get_tree().root.get_node("Room/UICanvasLayer")
	if ui:
		ui.updateKilled(killed)	
		
func toggle_main_bus_mute():
	var current_mute = AudioServer.is_bus_mute(0)
	AudioServer.set_bus_mute(0, not current_mute) 
	
func _unhandled_input(event):

	if event.is_action_pressed("mute"):
		toggle_main_bus_mute()
func dyingPlayer():
	player.dead=true
	player.crouch=10
	Engine.time_scale=0.1
func deadPlayer():
	_ready()
	player=null
	get_tree().reload_current_scene()
	
