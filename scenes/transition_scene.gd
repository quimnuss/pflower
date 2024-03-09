extends Node2D
@onready var oracle_animal = $OracleAnimal


# Called when the node enters the scene tree for the first time.
func _ready():
    oracle_animal.sprite.set_flip_h(true)


func start_dialog():
    # check if a dialog is already running
    if Dialogic.current_timeline != null:
        return

    Dialogic.start("timeline")
    get_viewport().set_input_as_handled()


func _on_area_2d_2_body_entered(body):
    start_dialog()
