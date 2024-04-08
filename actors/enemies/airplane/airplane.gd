extends Node2D

@onready var animation_player = $Hit/AnimationPlayer

var speed = 100

var is_debug: bool


func _ready():
    is_debug = OS.is_debug_build() and self == get_tree().current_scene
    if is_debug:
        self.global_position = Vector2i(500, 500)


func _physics_process(delta):
    position -= delta * Vector2(0, speed).rotated(rotation)


func _input(event):
    if is_debug and event is InputEventMouseButton:
        hit()


func hit():
    animation_player.play("hit")


func _on_area_2d_body_entered(body):
    print(body)
    if body is Animal:
        hit()


func _on_animation_player_animation_finished(anim_name):
    match anim_name:
        "hit":
            queue_free()


func _on_hurt_box_area_entered(area):
    hit()
