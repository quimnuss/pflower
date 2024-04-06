extends Node2D

class_name BeastHit
@onready var explosion = $Explosion

@onready var animation_player = $AnimationPlayer

signal destroyed


func _ready():
    animation_player.play("hit")
    explosion.visible = false


func _on_animation_player_animation_finished(anim_name):
    match anim_name:
        "hit":
            animation_player.play("explosion")
        "explosion":
            queue_free()
            destroyed.emit()
