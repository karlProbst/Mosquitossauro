extends Node2D


var player
func _process(delta: float) -> void:
	print(player)
	print(modulate.r)
	
	if not player:
		player = GlobalSingleton.getPlayer()
	else:
		print(player.global_position.x-292)
		if player.global_position.x-292>330:
			modulate.r=lerpf(modulate.r,5,delta)
		elif modulate.r<5:
			modulate.r=lerpf(modulate.r,1,delta*3)
		if modulate.r>4.9 and $AnimationPlayer.current_animation=="idle":
			$AnimationPlayer.play("startAttack")
		if $AnimationPlayer.get_current_animation_position() > 1.9 and $AnimationPlayer.get_current_animation_position() <2.1:
			if player.global_position.x-292>-200:
				GlobalSingleton.deadPlayer()
