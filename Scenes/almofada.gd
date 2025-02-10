extends RigidBody2D

@onready var interactible_controller = $InteractibleControllerClass
var player
var lockchute = false
func _ready() -> void:
	player=GlobalSingleton.getPlayer()
func _process(_delta: float) -> void:
	if player:
		if player.chutando==0:
			lockchute=false
	else:
		player=GlobalSingleton.getPlayer()		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("chute"):
		interactible_controller.takeDamage()
		if not lockchute:
			print_debug(player)
			if player:
			
				var player_velocity_x = player.velocity.x
				var maxplayerspeed=player.max_speed.x 
				var remapped_velocity_x = remap(player_velocity_x, -maxplayerspeed, maxplayerspeed, -0.8, 0.8)
				apply_central_impulse(Vector2(remapped_velocity_x,-1)*1350)
				lockchute=true
