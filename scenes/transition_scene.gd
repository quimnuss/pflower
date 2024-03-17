extends Node2D
@onready var oracle_animal = $OracleAnimal
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

    get_tree().call_group(Globals.PLAYERS_GROUP, "set_terrain_transform", false)


func give_abilities_and_unlock_exit():
    get_tree().call_group(Globals.PLAYERS_GROUP, "set_terrain_transform", true)
    collision_shape_2d.disabled = true
    progress_block.disabled = true


func start_dialog():
    if Dialogic.current_timeline != null:
        return

    var players = get_tree().get_nodes_in_group(Globals.PLAYERS_GROUP)
    get_tree().set_group(Globals.PLAYERS_GROUP, "player_controlled", false)
    get_tree().call_group(Globals.PLAYERS_GROUP, "stop")
    Dialogic.start("timeline")
    get_viewport().set_input_as_handled()
    await Dialogic.timeline_ended
    get_tree().set_group(Globals.PLAYERS_GROUP, "player_controlled", true)
    if Dialogic.VAR.has_oracle_gift:
        give_abilities_and_unlock_exit()


func _on_area_2d_2_body_entered(body):
    if body is Animal and not Dialogic.VAR.has_oracle_gift:
        start_dialog()
        #prints("has gift:", Dialogic.VAR.has_oracle_gift)
    else:
        #TODO activate speak interactible area button
        pass


const EXIT_SPEED: int = 100


func _on_to_level_1_body_entered(_body):
    var animals: Array[Node] = get_tree().get_nodes_in_group(Globals.PLAYERS_GROUP)
    const OFFSET = 30
    var count = 0
    for animal: Animal in animals:
        animal.player_controlled = false
        animal.stop()
        animal.global_position = _body.global_position + count * OFFSET * Vector2(1, 0)
        animal.velocity = Vector2(EXIT_SPEED, 0)
        count += 1
    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://scenes/level0.tscn")
