extends Camera2D

@export var followNode:Node2D
@export var followNode2:Node2D
var toPcView=0
var posToGo:Vector2
var toNextStage=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom.x=1.8
	zoom.y=zoom.x
	$ColorRect.visible=true
	position.x=followNode.position.x+300
	position_smoothing_enabled=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if toPcView==2:
		if Input.is_action_just_released("computer"):
			toPcView=0
	if Input.is_action_pressed("ui_cancel"):
		toPcView=0
		
	if not toNextStage:
		if $ColorRect.modulate.a>0:
			$ColorRect.modulate.a-=delta/1.2
	else:
		if $ColorRect.modulate.a<100:
			$ColorRect.modulate.a+=delta/1.2

	if toPcView==1:
		if get_parent().get_node("OldMan").modulate.a>0:
			get_parent().get_node("OldMan").modulate.a-=delta
		position.x=lerpf(position.x,posToGo.x,delta)
		position.y=lerpf(position.y,posToGo.y,delta)
		
		zoom.x=lerpf(zoom.x,4*6,delta)
		zoom.y=lerpf(zoom.y,3*6,delta)
		if zoom.x>4*5.9 and zoom.y>3*5.9:
			toPcView=2
	if toPcView==0:
		if get_parent().get_node("OldMan").modulate.a<1:
			get_parent().get_node("OldMan").modulate.a+=delta
		position.x=followNode.position.x+300
		zoom.x=lerpf(zoom.x,1.8,delta*5)
		zoom.y=lerpf(zoom.y,1.8,delta*5)


func zoomIn(pos:Vector2):
	if pos:
		toPcView=1
		posToGo=pos
		
func zoomOut():
	toPcView=0
