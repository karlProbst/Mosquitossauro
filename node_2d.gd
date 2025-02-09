extends Node2D

@onready var pointA = $pointA
@onready var pointB = $pointB
@onready var ponto = $Ponto
var newVector
var vector1
var vector2 
var a = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vector1 = pointA.position
	vector2 = pointB.position

	ponto.position=vector1
	

func _process(delta: float) -> void:
	a += delta
	newVector = vector2-vector1*cos(get_angle_to(vector1))*sin(a)
	ponto.position+=newVector*delta
