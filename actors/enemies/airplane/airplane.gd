extends Node2D

var speed = 100


func _process(delta):
    position -= delta * Vector2(0, speed).rotated(rotation)
