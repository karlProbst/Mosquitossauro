extends Node2D

var dist
const BUTTON_RADIUS=7
var spawner = Spawner.new()
var buying:bool = false

func _process(_delta: float) -> void:
	if buying:
		var mouse_position = get_global_mouse_position()
		var raqueteCentro = $PC/BuyRaquete.global_position  
		var distanceRaquete = mouse_position.distance_to(raqueteCentro)

		var sprayCentro = $PC/BuySpray.global_position  
		var distanceSpray = mouse_position.distance_to(sprayCentro)
	
		var awpCentro = $PC/BuyAwp.global_position  
		var distanceAwp = mouse_position.distance_to(awpCentro)
		if distanceRaquete <= BUTTON_RADIUS:
			if GlobalSingleton.killed>=30:
				get_parent().get_node("OldMan").hitTest(raqueteCentro)
				spawnBox("raquete")
				GlobalSingleton.killed-=30
		if distanceSpray <= BUTTON_RADIUS:
			if GlobalSingleton.killed>=60:
				get_parent().get_node("OldMan").hitTest(sprayCentro)
				spawnBox("spray")
				GlobalSingleton.killed-=60
		if distanceAwp <= BUTTON_RADIUS:
			if GlobalSingleton.killed>=199:
				get_parent().get_node("OldMan").hitTest(awpCentro)
				spawnBox("awp")
				GlobalSingleton.killed-=199
				
				
func spawnBox(item):
	var boxScene=preload("res://Scenes/box.tscn")
	var instance = spawner.Instantiate(boxScene,Vector2(-1000,300),get_parent())
	spawner.InjectArgs(instance,{"item":item})
