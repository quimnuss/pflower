extends Node2D

@export var tilemap: TileMap

signal set_ground_tile(new_position: Vector2)

var last_position: Vector2 = Vector2(-1, -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if global_position == last_position:
        return
    last_position = global_position
    set_ground_tile.emit(global_position)
