extends Area2D

var cycle = 0
var agro = false
func _process(delta: float) -> void:
	cycle +=delta
	if agro:
		modulate.r=lerpf(modulate.r,5,delta*1.8)
	elif modulate.r<5:
		modulate.r=lerpf(modulate.r,1+sin(cycle),delta*3)
	if modulate.r>4.9 and $AnimationPlayer.current_animation=="idle":
		$AnimationPlayer.play("startAttack")
	if $AnimationPlayer.get_current_animation_position() > 5.9:
		$AnimationPlayer.play("idle")


func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(body):
		if body.is_in_group("player"):
			agro=true

func _on_body_exited(body: Node2D) -> void:
		if is_instance_valid(body):
			if body.is_in_group("player"):
				agro=false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_instance_valid(body):
			if body.is_in_group("player"):
				GlobalSingleton.deadPlayer()
