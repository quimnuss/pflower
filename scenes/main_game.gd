extends Node2D

@onready var tilemap: PfTileMap = $TileMap
@onready var win_scene = $WinScene
@onready var animal = $Animal
@onready var animal_2 = $Animal2
@onready var marker_2d = $Marker2D
@onready var camera_2d = $Camera2D
@onready var movement_tail = $Enemies/MovementTail
@onready var lifebar = $CanvasLayer/Lifebar

var world_size: int = 100

var restored_world: int = 0
var restored_percent: float = 0
var game_ended: bool = false

const RESTORATION_MULTIPLIER: float = 2.0

signal restoration(restoration_percent: float)


func _ready():
    world_size = len(tilemap.get_used_cells(tilemap.TERRAIN_LAYER))

    if Globals.players:
        animal.queue_free()
        animal_2.queue_free()

        var animals: Array[Animal] = Globals.load_players(marker_2d.global_position)
        for _animal in animals:
            self.add_child(_animal)
    else:
        animal.hit.connect(Globals.lower_health)
        animal.add_to_group("players")
        animal_2.hit.connect(Globals.lower_health)
        animal_2.add_to_group("players")

    Globals.health_changed.connect(lifebar.set_health)
    Globals.health_changed.connect(check_death)

    movement_tail.targets = get_tree().get_nodes_in_group("players")


func _input(event):
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
    if event.is_action_pressed("cheat_action"):
        win_game()


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
    win_scene.set_has_won(true)
    win_scene.visible = true
    Input.start_joy_vibration(0, 0.25, 0.5, 2)
    Input.start_joy_vibration(1, 0.25, 0.5, 2)
    get_tree().call_group("enemies", "_on_game_won")
    tilemap.auto_restore()


func lose_game():
    game_ended = true
    win_scene.set_has_won(false)
    win_scene.visible = true
    Input.start_joy_vibration(0, 0.25, 0.5, 2)
    Input.start_joy_vibration(1, 0.25, 0.5, 2)
    get_tree().call_group("enemies", "_on_game_won")


func check_death(health: int):
    if health == 0:
        lose_game()


func _on_restoration_changed(_restoration: float):
    if _restoration >= 100 and not game_ended:
        win_game()


func _on_tile_map_tile_changed(tile_coords, previous_tile_type, tile_type):
    cell_changed(tile_coords, previous_tile_type, tile_type)


func _on_replay_pressed():
    get_tree().change_scene_to_file("res://scenes/landing_scene.tscn")


func _on_exit_pressed():
    get_tree().quit()


func _on_retry_pressed():
    Globals.reset_health()
    get_tree().reload_current_scene()
