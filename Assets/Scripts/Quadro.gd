extends Area2D

@onready var interactible_controller = $InteractibleControllerClass

func _ready() -> void:
	if interactible_controller:
		interactible_controller.health = 2


func _on_area_entered(area: Node) -> void:
	if area.is_in_group("chute"):
		interactible_controller.takeDamage()
