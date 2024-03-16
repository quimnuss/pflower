extends Node2D
@onready var oracle_animal = $OracleAnimal
@onready var animal = $Animal
@onready var camera_2d = $Camera2D
@onready var marker_2d = $Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
    oracle_animal.sprite.set_flip_h(true)

    if not Globals.players:
        animal.set_terrain_transform(false)
    else:
        animal.queue_free()

        var animals: Array[Animal] = Globals.load_players(marker_2d.global_position)
        for _animal: Animal in animals:
            self.add_child(_animal)
            _animal.set_terrain_transform(false)
        animal = animals[0]
        camera_2d.target = animals[0]


func start_dialog():
    if Dialogic.current_timeline != null:
        return

    animal.player_controlled = false
    animal.stop()
    Dialogic.start("timeline")
    get_viewport().set_input_as_handled()
    await Dialogic.timeline_ended
    animal.player_controlled = true
    animal.set_terrain_transform(true)


func _on_area_2d_2_body_entered(body):
    if body is Animal:
        start_dialog()
        #prints("has gift:", Dialogic.VAR.has_oracle_gift)


func _on_to_level_1_body_entered(_body):
    animal.player_controlled = false
    animal.stop()
    animal.velocity = Vector2(animal.speed, 0)
    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://scenes/level0.tscn")
