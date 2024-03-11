extends Node2D
@onready var oracle_animal = $OracleAnimal
@onready var animal = $Animal
@onready var camera_2d = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
    if not Globals.players:
        Globals.players.append(PlayerData.new())
    oracle_animal.sprite.set_flip_h(true)
    animal.set_terrain_transform(false)

    for player_data in Globals.players:
        var player_animal: Animal = Animal.from_settings(player_data)
        player_animal.global_position = animal.global_position
        animal.queue_free()
        add_child(player_animal)
        animal = player_animal
        camera_2d.target = player_animal
        player_animal.set_terrain_transform(false)


func start_dialog():
    if Dialogic.current_timeline != null:
        return

    animal.player_controlled = false
    animal.stop()
    var dialog = Dialogic.start("timeline")
    get_viewport().set_input_as_handled()
    await Dialogic.timeline_ended
    animal.player_controlled = true
    animal.set_terrain_transform(true)


func _on_area_2d_2_body_entered(body):
    if body is Animal:
        start_dialog()
        #prints("has gift:", Dialogic.VAR.has_oracle_gift)


func _on_to_level_1_body_entered(body):
    animal.player_controlled = false
    animal.stop()
    animal.velocity = Vector2(animal.speed, 0)
    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://scenes/main_game.tscn")
