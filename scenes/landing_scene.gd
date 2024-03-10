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


func add_animal(animal_type: String, player_suffix: String):
    var animal_resource: Resource = load("res://data/lifeform_" + animal_type + ".tres")
    var new_animal: Animal = load("res://actors/player_animal.tscn").instantiate()
    Animal.from_resource(new_animal, animal_resource)
    new_animal.player_suffix = player_suffix
    add_child(new_animal)


func _on_input_detector_new_player(device_type: String, player_num: int):
    prints(device_type, player_num)
    var animal_types: Array[String] = ["fox", "boar", "rabbit", "stag", "wolf"]
    var animal_type: String = animal_types.pick_random()
    var player_suffix = device_type + "_" + str(player_num)
    add_animal(animal_type, player_suffix)


func _on_play_game_body_entered(body):
    get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")
