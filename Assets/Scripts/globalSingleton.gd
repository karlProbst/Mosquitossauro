extends Node
@export var max_health:int=6
var health:int
var killed:int

var player:Node2D
var camera:Node
var item:String = ""
func _ready():
	initialize()
func initialize():
	health = max_health
	killed = 0
func setStoredItem(str:String)->void:
	item = str
func getStoredItem()->String:
	if item=="":
		print_debug("No Item stored")
	var tempItem=item
	#item=""
	return tempItem

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
	var ui =  get_tree().root.get_node("Root/UICanvasLayer")
	if ui:
		ui.updateHealth(health)
func add_kill(n:int=1):
	killed+=n

	var ui =  get_tree().root.get_node("Root/UICanvasLayer")
	if ui:
		ui.updateKilled(killed)	
		
func toggle_main_bus_mute():
	var current_mute = AudioServer.is_bus_mute(0)
	AudioServer.set_bus_mute(0, not current_mute) 
	
func _unhandled_input(event):

	if event.is_action_pressed("mute"):
		toggle_main_bus_mute()
	if event.is_action_pressed("pause"):
		if player:
			player.caffeine=0
		Engine.time_scale = 1.0 if Engine.time_scale == 0.0 else 0.0

func dyingPlayer():
	player.caffeine=0
	player.dead=true
	player.crouch=10
	Engine.time_scale=0.1
func deadPlayer():
	initialize()
	player=null
	get_tree().reload_current_scene()
	
