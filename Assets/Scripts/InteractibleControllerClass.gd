extends Node

class_name InteractibleControllerClass

@export var audio_player_node: AudioStreamPlayer2D
@export var animation_player_node: AnimationPlayer

var defaultKickSound = preload("res://Assets/Sound/paaa.wav")
@export var health:int=2
signal destroyed
signal tookDamage
func _on_area_entered(area: Node) -> void:
	if area.is_in_group("chute") or area.is_in_group("almofada"):
		takeDamage()
		

func _ready() -> void:
	if get_parent().has_signal("area_entered"):
		if get_parent().has_method("_on_area_entered"):
			if not get_parent().is_connected("area_entered",Callable(get_parent(), "_on_area_entered")):
				get_parent().connect("area_entered", Callable(get_parent(), "_on_area_entered"))
		elif get_parent().has_signal("area_entered"):
				get_parent().connect("area_entered", Callable(self, "_on_area_entered"))

		audio_player_node = get_parent().get_node_or_null("AudioStreamPlayer2D")
	if not animation_player_node:
		animation_player_node = get_parent().get_node_or_null("AnimationPlayer")
		
func takeDamage(damage:int=1,_anim:String = "takeDamage") -> void:
	
	if health==-1:
		playSound()
		playAnimation()
	if health>0:
		playSound()
		removeHealth(damage)
	if health>0:
		playAnimation()
	emit_signal("tookDamage")
		
func playAnimation(animStr:String="takeDamage"):
	if animation_player_node:
		if animation_player_node.has_animation(animStr):
			animation_player_node.play(animStr)
			animation_player_node.seek(0)


#TODO: TIPAR CUSTOMSOUND
func playSound(customSound=null)-> void:
	if audio_player_node:
		if customSound and customSound is AudioStream:
			audio_player_node.stream = customSound
		elif audio_player_node.stream == null:
			audio_player_node.stream = defaultKickSound
		audio_player_node.play()
func removeNode():
	var animPlayer = get_parent().get_node_or_null("AnimationPlayer")
	if animPlayer and animPlayer.has_animation("destroy"):
		playAnimation("destroy")
	elif not get_parent().has_method("destroy"):
		get_parent().visible=false
		#Checks if audio is playing and waits it to finish before deleting. 
		if audio_player_node and audio_player_node.playing:
			
			audio_player_node.connect("finished", Callable(get_parent(),"queue_free"))
		else:
			get_parent().queue_free()
	else:
		get_parent().queue_free()
func removeHealth(damage:int=1):
	health-=damage
	if health<=0:
		emit_signal("destroyed")
		health=0
		if get_parent().has_method("cairNoChao"):
			get_parent().cairNoChao()
		else:
			removeNode()
