extends Node2D

var hit_animation = preload("res://components/beast_hit.tscn")

var speed = 100

var is_debug: bool


func _ready():
    is_debug = OS.is_debug_build() and self == get_tree().current_scene
    if is_debug:
        self.global_position = Vector2i(500, 500)


func _process(delta):
    position -= delta * Vector2(0, speed).rotated(rotation)


func _input(event):
    if is_debug and event is InputEventMouseButton:
        hit()


func destroyed():
    queue_free()


func hit():
    var hit_scene: BeastHit = hit_animation.instantiate()
    hit_scene.destroyed.connect(destroyed)
    add_child(hit_scene)


func _on_area_2d_body_entered(body):
    if body is Animal:
        hit()
