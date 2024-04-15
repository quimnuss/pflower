extends Node2D

@export var sprite: Sprite2D
@onready var dust = $Dust
@onready var dust_burst = $DustBurst

var elapsed: float = 0


func _ready():
    deactivate()


func deactivate():
    set_process(false)
    dust.emitting = false
    dust_burst.emitting = false


func activate():
    set_process(true)
    dust.restart()
    dust_burst.restart()
    dust.emitting = true
    dust_burst.emitting = true
    dust_burst.rotation = (-get_parent().velocity.normalized()).angle()


func _process(delta):
    elapsed += delta
    if elapsed >= 0.03:
        elapsed = 0
        instance_ghost()


func instance_ghost():
    var ghost: Sprite2D = GhostSprite.Instance(sprite)
    get_parent().get_parent().add_child(ghost)
