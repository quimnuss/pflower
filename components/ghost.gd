extends Node2D

@export var sprite: Sprite2D

var elapsed: float = 0


func _ready():
    set_process(false)


func _process(delta):
    elapsed += delta
    if elapsed >= 0.03:
        elapsed = 0
        instance_ghost()


func instance_ghost():
    var ghost: Sprite2D = GhostSprite.Instance(sprite)
    get_parent().get_parent().add_child(ghost)


func _on_ghost_timer_timeout():
    instance_ghost()
