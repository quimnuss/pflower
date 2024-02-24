extends Node2D

@onready var tilemap = $TileMap
@onready var win_scene = $WinScene

const TILESIZE : int = 16

var world_size : int = 100

var restored_world : int = 0
var restored_percent : float = 0

const RESTORATION_MULTIPLIER : float = 3.0

signal restoration(restoration_percent : float)

func _ready():
    var viewport_size : Vector2i = get_viewport().size/TILESIZE
    world_size = viewport_size.x * viewport_size.y

func _input(event):
    if event is InputEventMouseButton:
        var tile_coords : Vector2i = tilemap.local_to_map(event.global_position)
        var tiledata : TileData = tilemap.get_cell_tile_data(1, tile_coords)

func cell_changed(tile_coords : Vector2i, previous_terrain_type : PfTileMap.TileType, terrain_type : PfTileMap.TileType):
    if terrain_type == PfTileMap.TileType.GROUND:
        restored_world -= 1
    elif previous_terrain_type == PfTileMap.TileType.GROUND and terrain_type != PfTileMap.TileType.GROUND:
        restored_world += 1
    else:
        # global cound didnt change
        return
    restored_percent = 100*restored_world/world_size
    restoration.emit(RESTORATION_MULTIPLIER*restored_percent)

func _on_restoration_changed(restoration : float):
    if restoration >= 100:
        win_scene.visible = true

func _on_tile_map_tile_changed(tile_coords, previous_tile_type, tile_type):
    cell_changed(tile_coords, previous_tile_type, tile_type)
