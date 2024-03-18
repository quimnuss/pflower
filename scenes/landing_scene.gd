extends Node2D

@onready var graphics_settings_node = $GraphicsSettingsNode
@onready var animal = $Animal
@onready var hard_difficulty_node = $HardDifficultyNode
@onready var spawn_marker = $SpawnMarker
@onready var single_player_info_label = $SinglePlayerInfoLabel
@onready var available_inputs = $Label/AvailableInputs
@onready var input_detector = $InputDetector

@onready var tilemap = $TileMap

var next_skill: int = 1

var is_exiting: bool = false


func _ready():
    animal.queue_free()
    Globals.players.clear()

    graphics_settings_node.setting_change = flip_graphics
    hard_difficulty_node.setting_change = flip_hard_difficulty

    graphics_settings_node.activate(Globals.use_particles)
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


func add_animal(species: Animal.Species, player_suffix: String):
    var mouse_movement = "mouse_0" == player_suffix
    var player_data: PlayerData = PlayerData.New(species, player_suffix, mouse_movement, next_skill)
    Globals.players.append(player_data)
    var new_animal: Animal = Animal.from_settings(player_data)
    new_animal.global_position = spawn_marker.global_position
    add_child(new_animal)
    next_skill = (next_skill + 1) % 2


func _on_input_detector_new_player(device_type: String, device_num: int):
    var species: Animal.Species = randi_range(Animal.Species.FOX, Animal.Species.DOE) as Animal.Species
    if not Globals.players:
        species = Animal.Species.BEAR
        single_player_info_label.visible = true
    else:
        single_player_info_label.visible = false
    prints("new player", device_type, device_num, Animal.species_name[species])
    var player_suffix = device_type + "_" + str(device_num)
    add_animal(species, player_suffix)
    available_inputs.text = "".join(input_detector.available_inputs.values())


func _on_play_game_body_entered(_body):
    if not is_exiting:
        is_exiting = true
        get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")
