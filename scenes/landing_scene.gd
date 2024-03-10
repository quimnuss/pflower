extends Node2D

@onready var graphics_settings_node = $GraphicsSettingsNode
@onready var animal = $Animal
@onready var input_selection_node = $InputSelectionNode
@onready var hard_difficulty_node = $HardDifficultyNode


func _ready():
    graphics_settings_node.setting_change = flip_graphics
    input_selection_node.setting_change = flip_use_mouse
    hard_difficulty_node.setting_change = flip_hard_difficulty

    graphics_settings_node.activate(Globals.use_particles)
    input_selection_node.activate(Globals.use_mouse)
    hard_difficulty_node.activate(Globals.hard_difficulty)


func flip_hard_difficulty():
    Globals.hard_difficulty = not Globals.hard_difficulty
    return Globals.hard_difficulty


func flip_graphics():
    Globals.use_particles = not Globals.use_particles
    if Globals.use_particles:
        var smoke = load("res://components/explosion.tscn").instantiate()
        graphics_settings_node.add_child(smoke)
    return Globals.use_particles


func flip_use_mouse():
    Globals.use_mouse = not Globals.use_mouse
    if Globals.use_mouse:
        animal.mouse_movement = true
    else:
        animal.mouse_movement = false
    return Globals.use_mouse


func _on_input_detector_new_player(device_type: String, player_num: int):
    prints(device_type, player_num)


func _on_play_game_body_entered(body):
    get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")
