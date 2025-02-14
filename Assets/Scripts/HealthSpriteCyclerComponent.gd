extends Node

class_name HealthSpriteCyclerComponent

@onready var interactibleControllerClass:InteractibleControllerClass=get_parent().get_node("InteractibleControllerClass")
@onready var spritesFatherNode:Node2D=get_parent().get_node("HealthSprites")
var spritesN
var healthMax
func _ready() -> void:
	if interactibleControllerClass and spritesFatherNode:
		healthMax = interactibleControllerClass.health
		spritesN = spritesFatherNode.get_children()
		interactibleControllerClass.connect("tookDamage", Callable(self, "UpdateSprite"))

func UpdateSprite():
	
	var health = interactibleControllerClass.health
	var percentage = float(health) / float(healthMax)
	var index = ceil(percentage * (spritesN.size() - 1))
	for i in range(spritesN.size()):
		spritesN[i].visible=false
		if str(index) ==  str(spritesN[i].name):
			spritesN[i].visible=true
