extends PathFollow2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    progress_ratio += 0.1 * delta
