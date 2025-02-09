extends Node

class_name InteractibleControllerClass

@export var audio_player_node: AudioStreamPlayer2D
@export var animation_player_node: AnimationPlayer

var defaultKickSound = preload("res://Assets/Sound/paaa.wav")
@export var health:int=2

func _on_area_entered(area: Node) -> void:
	if area.is_in_group("chute"):
		takeDamage()

func _ready() -> void:
	#if get_parent().has_method("_on_area_entered"):
	#	get_parent().connect("area_entered", Callable(get_parent(), "_on_area_entered"))
	#else:
	#	get_parent().connect("area_entered", Callable(self, "_on_area_entered"))
		
		
	if not audio_player_node:
		audio_player_node = get_parent().get_node_or_null("AudioStreamPlayer2D")
	if not animation_player_node:
		animation_player_node = get_parent().get_node_or_null("AnimationPlayer")
		
func takeDamage(damage:int=1,customSound:AudioStream = defaultKickSound,anim:String = "takeDamage") -> void:
	
	if health>0:
		playSound(customSound)
		removeHealth(damage)
		playAnimation()
		
func playAnimation(animStr:String="takeDamage"):
	if animation_player_node:
		if animation_player_node.has_animation(animStr):
			animation_player_node.play(animStr)
			animation_player_node.seek(0)


#TODO: TIPAR CUSTOMSOUND
func playSound(customSound:AudioStream)-> void:
	if audio_player_node:
		if customSound:
			audio_player_node.stream = customSound
		else:
			audio_player_node.stream = defaultKickSound
		audio_player_node.play()
	else:
		print_debug("Warning: AudioStreamPlayer2D not found!")

func removeNode():

	if not get_parent().has_method("destroy"):
		get_parent().visible=false
		#Checks if audio is playing and waits it to finish before deleting. 
		if audio_player_node and audio_player_node.playing:
			
			audio_player_node.connect("finished", Callable(get_parent(),"queue_free"))
		else:
			get_parent().queue_free()
	else:
		var animPlayer = get_parent().get_node("AnimationPlayer")
		if animPlayer and animPlayer.has_animation("destroy"):
			animPlayer.play("destroy")
		get_parent().destroy()
func removeHealth(damage:int=1):
	health-=damage
	if health<=0:
		health=0
		if get_parent().has_method("cairNoChao"):
			get_parent().cairNoChao()
		else:
			removeNode()
