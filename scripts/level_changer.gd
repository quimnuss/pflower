extends Node2D

@export var level_name: String
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var label = $Label


func activate_cheats():
    self.visible = true
    label.text = level_name
    collision_shape_2d.disabled = false


func _on_area_2d_body_entered(body):
    get_tree().change_scene_to_file("res://scenes/" + level_name + ".tscn")
