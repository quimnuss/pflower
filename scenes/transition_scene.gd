extends Node2D
@onready var oracle_animal = $OracleAnimal
@onready var animal = $Animal
@onready var camera = $Camera2D
@onready var area_2d_2 = $OracleAnimal/Area2D2
@onready var collision_shape_2d = $OracleAnimal/Area2D2/CollisionShape2D
@onready var progress_block = $ToLevel1/StaticBody2D/ProgressBlock


# Called when the node enters the scene tree for the first time.
func _ready():
    oracle_animal.sprite.set_flip_h(true)

    var animals: Array = get_tree().get_nodes_in_group(Globals.PLAYERS_GROUP)
    if not animals:
        push_error("No players in group players")
        return
    else:
        prints("Animals", animals)

    camera.target = animals[0]
    camera.global_position = camera.target.global_position

    get_tree().call_group("players", "set_terrain_transform", true)


func give_abilities_and_unlock_exit():
    get_tree().call_group("players", "set_terrain_transform", true)
    collision_shape_2d.disabled = true
    progress_block.disabled = true


func start_dialog():
    if Dialogic.current_timeline != null:
        return

    animal.player_controlled = false
    animal.stop()
    get_tree().call_group("players", "set_player_controlled", false)
    get_tree().call_group("players", "stop")
    Dialogic.start("timeline")
    get_viewport().set_input_as_handled()
    await Dialogic.timeline_ended
    animal.player_controlled = true
    get_tree().call_group("players", "set_player_controlled", true)
    if Dialogic.VAR.has_oracle_gift:
        give_abilities_and_unlock_exit()


func _on_area_2d_2_body_entered(body):
    if body is Animal and not Dialogic.VAR.has_oracle_gift:
        start_dialog()
        #prints("has gift:", Dialogic.VAR.has_oracle_gift)
    else:
        #TODO activate speak interactible area button
        pass


func _on_to_level_1_body_entered(_body):
    animal.player_controlled = false
    animal.stop()
    animal.velocity = Vector2(animal.speed, 0)
    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://scenes/level0.tscn")
