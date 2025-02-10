extends Node

enum States { UNACTIVE, HIGHLIGHT, BUYING, BROKEN }
var state: States = States.UNACTIVE
var parent = get_parent()
func _ready() -> void:
	
	if parent.has_signal("area_entered") and parent.has_method("_on_area_entered") and not parent.is_connected("area_entered",Callable(parent, "_on_area_entered")):
		parent.connect("area_entered", Callable(parent, "_on_area_entered"))


func _process(delta: float) -> void:
	pass
