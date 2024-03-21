extends Marker2D

@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var path_2d = $Path2D


func spawn_parabolic():
    path_2d.reset()


func _on_timer_timeout():
    spawn_parabolic()
