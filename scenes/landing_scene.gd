extends Node2D

@onready var graphics_settings_node = $GraphicsSettingsNode
@onready var animal = $Animal
@onready var input_selection_node = $InputSelectionNode
@onready var hard_difficulty_node = $HardDifficultyNode
@onready var spawn_marker = $SpawnMarker

@onready var tilemap = $TileMap

var next_skill: int = 1


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
    var animal_resource: Resource = load("res://data/lifeform_" + Animal.species_name[species] + ".tres")
    var mouse_movement = "mouse_0" == player_suffix
    var player_data: PlayerData = PlayerData.New(species, player_suffix, mouse_movement, next_skill)
    var new_animal: Animal = Animal.from_settings(player_data)
    new_animal.global_position = spawn_marker.global_position
    add_child(new_animal)
    next_skill = (next_skill + 1) % 2


func _on_input_detector_new_player(device_type: String, device_num: int):
    var species: Animal.Species = randi_range(Animal.Species.BEAR, Animal.Species.DOE)
    prints("new player", device_type, device_num, Animal.species_name[species])
    var player_suffix = device_type + "_" + str(device_num)
    add_animal(species, player_suffix)


func _on_play_game_body_entered(body):
    get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")
