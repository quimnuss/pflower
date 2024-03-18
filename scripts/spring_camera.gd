extends Node2D

const MAX_CAMERA_SHIFT: int = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    var mouse_pos: Vector2 = get_global_mouse_position()
    get_parent().offset = (mouse_pos - global_position) / ((get_viewport().size as Vector2) / 2.0) * MAX_CAMERA_SHIFT
