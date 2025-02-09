extends Camera2D

@export var followNode:Node2D
@export var followNode2:Node2D
var toPcView=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom.x=1.8
	zoom.y=zoom.x
	$ColorRect.visible=true
	position.x=followNode.position.x+300
	position_smoothing_enabled=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if toPcView==0 or toPcView==2:
		if Input.is_action_pressed("computer"):
			toPcView=1
	if Input.is_action_pressed("ui_cancel"):
		toPcView=0
	if $ColorRect.modulate.a>0:
		$ColorRect.modulate.a-=delta/1.2
	

	if toPcView==1:
		if get_parent().get_node("OldMan").modulate.a>0:
			get_parent().get_node("OldMan").modulate.a-=delta
		position.x=lerpf(position.x,389,delta)
		position.y=lerpf(position.y,392,delta)
		
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
