extends PathFollow2D

@onready var enemy_bulldozer = $EnemyBulldozer

var last_position: Vector2 = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if enemy_bulldozer.can_move:
        progress_ratio += 0.1 * delta
        var direction: Vector2 = position - last_position
        var goes_right = direction.x > 0
        enemy_bulldozer.flip_h(goes_right)
        last_position = position
