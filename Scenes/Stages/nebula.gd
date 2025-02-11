extends Node2D



func _process(delta):
	$TextureRect2.texture.noise.offset.x += delta*10
