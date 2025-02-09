extends Node

var health
var killed
var dead
func _ready():
	
	health = 10
	killed = 0
	dead = false	
	
func remove_hearts(count:int)->void:
	health-=count
	if health<=0:
		dead=true
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
