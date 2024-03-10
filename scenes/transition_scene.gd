extends Node2D
@onready var oracle_animal = $OracleAnimal
@onready var animal = $Animal


# Called when the node enters the scene tree for the first time.
func _ready():
    oracle_animal.sprite.set_flip_h(true)
    animal.set_terrain_transform(false)

    animal.mouse_movement = Globals.use_mouse


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


func _on_to_level_1_body_entered(body):
    animal.player_controlled = false
    animal.stop()
    animal.velocity = Vector2(animal.speed, 0)
    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://scenes/main_game.tscn")
