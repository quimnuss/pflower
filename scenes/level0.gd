extends Node2D

@onready var camera: PfCamera = $RestorationGame/Camera2D
@onready var win_scene = $win_scene


# Called when the node enters the scene tree for the first time.
func _ready():
    var animals: Array = get_tree().get_nodes_in_group(Globals.PLAYERS_GROUP)
    if not animals:
        push_error("No players in group players")
        return
    camera.target = animals[0]
    camera.global_position = camera.target.global_position


func win_game():
    win_scene.visible = true
    Input.start_joy_vibration(0, 0.25, 0.5, 2)
    Input.start_joy_vibration(1, 0.25, 0.5, 2)
    get_tree().call_group("enemies", "_on_game_won")


func _on_restoration_game_restoration_complete():
    win_game()


func _on_raft_exit_level():
    await get_tree().create_timer(3).timeout
    get_tree().change_scene_to_file("res://scenes/main_game.tscn")
