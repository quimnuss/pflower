extends Node2D

var foot_scene = preload("res://actors/enemies/foot/foot.tscn")
@onready var foot_spawn_timer = $FootSpawnTimer
@onready var camera_2d = $"../../Camera2D"

const HARD_WAIT_TIME: int = 10
@export var wait_time: int = 20

signal add_trauma(amount: float)


# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group("enemies")
    if Globals.hard_difficulty:
        wait_time = HARD_WAIT_TIME
    foot_spawn_timer.start(wait_time)


func random_position():
    var x_range = Vector2(100, 400)
    var y_range = Vector2(100, 200)

    var random_x = randi() % int(x_range[1] - x_range[0]) + 1 + x_range[0]
    var random_y = randi() % int(y_range[1] - y_range[0]) + 1 + y_range[0]
    var random_pos = Vector2(random_x, random_y)
    return random_pos


func add_trauma_proxy(amount: float):
    add_trauma.emit(amount)


func _on_game_won():
    foot_spawn_timer.stop()


func _on_foot_spawn_timer_timeout():
    var foot_enemy: Foot = foot_scene.instantiate()
    foot_enemy.global_position = random_position()
    foot_enemy.stomped.connect(add_trauma_proxy)
    add_child(foot_enemy)
