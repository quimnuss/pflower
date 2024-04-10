extends Node2D

@export var enemy_scene: PackedScene

@onready var edge_spawn_timer: Timer = $EdgeSpawnTimer

var random: RandomNumberGenerator


func _ready():
    random = RandomNumberGenerator.new()
    random.randomize()
    add_to_group("enemy_spawner")


func stop():
    edge_spawn_timer.stop()


func random_edge_position() -> Vector2:
    var spawn_position: Vector2 = Vector2(random.randi_range(-100, 0), random.randi_range(-100, 0))
    return spawn_position


func spawn():
    var spawn_position = random_edge_position()
    var enemy = enemy_scene.instantiate()
    enemy.global_position = spawn_position
    add_child(enemy)


func _on_edge_spawn_timer_timeout():
    spawn()
