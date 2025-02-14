extends Node2D

var dist
const BUTTON_RADIUS=7
var spawner = Spawner.new()
var buying:bool = false

func _process(_delta: float) -> void:
	if buying:
		var mouse_position = get_global_mouse_position()
		var raqueteCentro = $Oldpc/BuyRaquete.global_position  
		var distanceRaquete = mouse_position.distance_to(raqueteCentro)

		var sprayCentro = $Oldpc/BuySpray.global_position  
		var distanceSpray = mouse_position.distance_to(sprayCentro)
	
		var awpCentro = $Oldpc/BuyAwp.global_position  
		var distanceAwp = mouse_position.distance_to(awpCentro)
		if Input.is_action_just_pressed("mouse_left"):
			if distanceRaquete <= BUTTON_RADIUS:
					spawnBox("raquete")
			if distanceSpray <= BUTTON_RADIUS:
					spawnBox("spray")
			if distanceAwp <= BUTTON_RADIUS:
					spawnBox("awp")
				
				
func spawnBox(item):
	print(item)
	var boxScene=preload("res://Scenes/box.tscn")
	var instance = spawner.Instantiate(boxScene,Vector2(-1000,300),get_tree().current_scene)
	spawner.InjectArgs(instance,{"item":item})


func _on_shop_controller_class_buying() -> void:
	buying=true


func _on_shop_controller_class_stopbuying() -> void:
	buying=false
