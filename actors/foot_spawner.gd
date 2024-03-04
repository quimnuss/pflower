extends Node2D

var foot_scene = preload("res://actors/enemies/foot/foot.tscn")
@onready var foot_spawn_timer = $FootSpawnTimer
@onready var camera_2d = $"../../Camera2D"

const WAIT_TIME: int = 10


# Called when the node enters the scene tree for the first time.
func _ready():
    foot_spawn_timer.start(WAIT_TIME)


func random_position():
    var x_range = Vector2(100, 400)
    var y_range = Vector2(100, 200)

    var random_x = randi() % int(x_range[1] - x_range[0]) + 1 + x_range[0]
    var random_y = randi() % int(y_range[1] - y_range[0]) + 1 + y_range[0]
    var random_pos = Vector2(random_x, random_y)
    return random_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_foot_spawn_timer_timeout():
    var foot_enemy: Foot = foot_scene.instantiate()
    foot_enemy.global_position = random_position()
    foot_enemy.stomped.connect(camera_2d.add_trauma.bind(0.8))
    add_child(foot_enemy)
