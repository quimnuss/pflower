extends Node2D

class_name MovementTail

@export var targets : Array[Node2D]
@export var min_distance : int = 10000
@export var speed : float = 50
@export var cant_touch_this : bool = true

func _physics_process(delta):
    if targets:
        var min_target_distance = 100000
        var tailed_target = targets[0]
        for target in targets:
            var distance = global_position.distance_squared_to(target.global_position)
            if min_target_distance > distance:
                min_target_distance = distance
                tailed_target = target
        var distance = global_position.distance_squared_to(tailed_target.global_position)
        if cant_touch_this and distance < min_distance:
            pass
        else:
            global_position = global_position.move_toward(tailed_target.global_position, delta*speed)
