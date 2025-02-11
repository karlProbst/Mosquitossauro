extends Node2D

var a = 0
var dist=0
var sk  =0
var fallen=false
func _process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider:
			if collider.is_in_group("chute"):
				$Paaa.play()
				sk+=0.12
	skew=sk/5
	if skew>0.28:
		fallen=true
	if fallen:
		position.y+=delta*3
		skew=0
		rotation_degrees=90
	if sk>0:
		sk-=delta
	var oldman=get_parent().get_node("OldMan")
	if oldman:	
		if oldman.position.x>position.x:
			dist = abs(position.x-200 - oldman.position.x)
		else:
			dist = abs(oldman.position.x- position.x+200)
	
		
		
	if dist<120:
		
		$Highlight.visible=true
		a+=delta
		$Highlight.skew=sin(a)/13
		$Highlight.scale.x=1+abs(sin(a)/13)
	else:
		$Highlight.visible=false
