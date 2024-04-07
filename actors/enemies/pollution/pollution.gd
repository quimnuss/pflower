extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $Area2D/CollisionShape2D


func _ready():
    animation_player.play("idle")


func _on_area_2d_body_entered(body):
    pass
    print("hitcloud")
    collision_shape_2d.disabled = true
    animation_player.play("hit")


func _on_animation_player_animation_finished(anim_name):
    match anim_name:
        "hit":
            queue_free()
            #animation_player.play('idle')


func _on_area_2d_area_entered(area):
    print("hitcloud")
    collision_shape_2d.disabled = true
    animation_player.play("hit")
