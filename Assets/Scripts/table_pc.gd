extends InteractibleClass

var a = 0
var dist
const BUTTON_RADIUS=7
var spawner = Spawner.new()

func _ready() -> void:
	health = 1
func _process(delta: float) -> void:
	if  get_parent().get_node("OldMan").position.x>position.x:
		dist = abs(position.x-200 - get_parent().get_node("OldMan").position.x)
	else:
		dist = abs(get_parent().get_node("OldMan").position.x- position.x+200)
	
		
		
	if dist<120:
		
		$Highlight.visible=true
		a+=delta
		$Highlight.skew=sin(a)/13
		$Highlight.scale.x=1+abs(sin(a)/13)
	else:
		$Highlight.visible=false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
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


func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("chute"):
		takeDamage()
