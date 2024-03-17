extends Node2D

@onready var tilemap: PfTileMap = $TileMap
@onready var spawn_marker_2d = $SpawnMarker2D

var world_size: int = 100

var restored_world: int = 0
var restored_percent: float = 0
var is_restoration_complete: bool = false

const RESTORATION_MULTIPLIER: float = 2.0

signal restoration(restoration_percent: float)

signal restoration_complete


func _ready():
    world_size = len(tilemap.get_used_cells(tilemap.TERRAIN_LAYER))


func cell_changed(_tile_coords: Vector2i, previous_terrain_type: PfTileMap.TileType, terrain_type: PfTileMap.TileType):
    if terrain_type == PfTileMap.TileType.GROUND:
        restored_world -= 1
    elif previous_terrain_type == PfTileMap.TileType.GROUND and terrain_type != PfTileMap.TileType.GROUND:
        restored_world += 1
    else:
        # global cound didnt change
        return
    @warning_ignore("integer_division")
    restored_percent = 100 * restored_world / world_size
    restoration.emit(RESTORATION_MULTIPLIER * restored_percent)


func _on_restoration_changed(_restoration: float):
    if _restoration >= 100 and not is_restoration_complete:
        is_restoration_complete = true
        tilemap.auto_restore()
        restoration_complete.emit()


func _on_tile_map_tile_changed(tile_coords, previous_tile_type, tile_type):
    cell_changed(tile_coords, previous_tile_type, tile_type)
