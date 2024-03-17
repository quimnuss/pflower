extends Node2D

class_name Raft

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var passengers: Array[Animal]

var can_move: bool = false
const speed = 100

signal exit_level


func _ready():
    animated_sprite_2d.play("default")


func move():
    animated_sprite_2d.play("move_right")
    can_move = true


func _process(delta):
    if can_move:
        global_position.x += delta * speed
        for passenger in passengers:
            passenger.global_position = global_position


func avengers_assemble():
    var animals = get_tree().get_nodes_in_group(Globals.PLAYERS_GROUP)
    for animal in animals:
        passengers.append(animal)
        animal.call_deferred("reparent", self)
        animal.player_controlled = false
        animal.stop()
        animal.set_process(false)
        animal.global_position = self.global_position


func _on_area_2d_body_entered(body):
    if body is Animal and len(passengers) == 0:
        avengers_assemble()
        move()
        exit_level.emit()
