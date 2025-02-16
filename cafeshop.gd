extends Node2D

var player
var buying
var time=0.0
func _process(delta: float) -> void:
	if buying:
		time-=delta
		if time<=0:
			get_parent().get_node("Area2D/ShopControllerClass").toInactive()
			buying=false
	else:
		time=0.5

func _on_shop_controller_class_buying() -> void:
	if not player:
		player=GlobalSingleton.getPlayer()
		player.caffeine+=2
		get_parent().get_node("TiririCafe").play()
	buying=true


func _on_shop_controller_class_stopbuying() -> void:
	buying=false
