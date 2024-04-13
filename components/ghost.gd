extends Node2D

@export var animated_sprite: AnimatedSprite2D


func instance_ghost():
    var ghost: Sprite2D = GhostSprite.Instance(animated_sprite)
    get_parent().get_parent().add_child(ghost)
