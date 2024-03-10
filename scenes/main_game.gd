extends Node2D

@onready var tilemap: PfTileMap = $TileMap
@onready var win_scene = $WinScene

const TILESIZE: int = 16

var world_size: int = 100

var restored_world: int = 0
var restored_percent: float = 0
var game_ended: bool = false

const RESTORATION_MULTIPLIER: float = 2.0
const WORLD_MARGIN: Vector2i = Vector2i(2, 2)

signal restoration(restoration_percent: float)


func _ready():
    #var num_cells = len(tilemap.get_used_cells(tilemap.TERRAIN_LAYER))

    var viewport_size: Vector2i = (get_viewport().size - WORLD_MARGIN) / TILESIZE
    world_size = viewport_size.x * viewport_size.y


func _input(event):
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()


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


func win_game():
    game_ended = true
    win_scene.visible = true
    Input.start_joy_vibration(0, 0.25, 0.5, 2)
    Input.start_joy_vibration(1, 0.25, 0.5, 2)
    get_tree().call_group("enemies", "_on_game_won")


func _on_restoration_changed(_restoration: float):
    if _restoration >= 100 and not game_ended:
        win_game()


func _on_tile_map_tile_changed(tile_coords, previous_tile_type, tile_type):
    cell_changed(tile_coords, previous_tile_type, tile_type)


func _on_replay_pressed():
    get_tree().reload_current_scene()


func _on_exit_pressed():
    get_tree().quit()
