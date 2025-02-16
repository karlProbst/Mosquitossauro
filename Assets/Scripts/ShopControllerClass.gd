extends Node

class_name ShopControllerClass

@export var intClass:Node
enum States { UNACTIVE, HIGHLIGHT, BUYING, BROKEN }
var state: States = States.UNACTIVE
@onready var parent = get_parent()

@export var shopNode:Node2D
@onready var audio_player_node
signal buying
signal stopbuying
func connectCallable(nodeWithSignal,signalStr:String,funcStr:String,nodeConnectTo):
	if nodeWithSignal and nodeConnectTo:
		if nodeWithSignal.has_signal(signalStr) and not nodeWithSignal.is_connected(signalStr,Callable(parent, funcStr)):
			nodeWithSignal.connect(signalStr, Callable(nodeConnectTo, funcStr))

func _ready() -> void:
	get_parent().get_parent().get_node("Highlight").visible=false	
	connectCallable(parent,"body_entered","_on_area_2d_body_entered",self)
	connectCallable(parent,"body_exited","_on_area_2d_body_exited",self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		state=States.HIGHLIGHT
		get_parent().get_parent().get_node("Highlight").visible=true
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		toInactive()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("interact"):
			if state==States.HIGHLIGHT:
				playSound()
				emit_signal("buying")
				state=States.BUYING
				GlobalSingleton.getCamera().zoomIn(shopNode.global_position)
		if event.is_action_pressed("ui_cancel"):
			if state==States.BUYING:
				state=States.HIGHLIGHT
				emit_signal("stopbuying")
				GlobalSingleton.getCamera().zoomOut()
#todo: add grandpa hand IK

func toInactive():
	state=States.UNACTIVE
	emit_signal("stopbuying")
	get_parent().get_parent().get_node("Highlight").visible=false
	GlobalSingleton.getCamera().zoomOut()

func playSound()-> void:
	if audio_player_node:
		audio_player_node.play()
