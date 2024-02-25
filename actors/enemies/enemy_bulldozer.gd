extends Node2D

@export var tilemap: PfTileMap

signal set_ground_tile(new_position: Vector2)

var last_position: Vector2 = Vector2(-1, -1)

const speed = 100

var is_root_scene: bool = false


func _ready():
    is_root_scene = self == get_tree().current_scene
    if is_root_scene:
        prints("I'm root scene")
        tilemap = PfTileMap.new()
        tilemap.tile_set = load("res://actors/pflower_tileset.tres")
        get_tree().get_root().add_child(tilemap)
    else:
        prints("I'm not root scene")


func _process(delta):
    if global_position == last_position:
        return
    last_position = global_position
    set_ground_tile.emit(global_position)
    if is_root_scene:
        tilemap.try_set_tile(global_position, PfTileMap.TileType.GROUND)


func _physics_process(delta):
    if is_root_scene:
        var input_direction: Vector2 = Input.get_vector("move_left_0", "move_right_0", "move_up_0", "move_down_0")
        if input_direction:
            global_position = global_position + delta * Vector2(speed, speed) * input_direction
