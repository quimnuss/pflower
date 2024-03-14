extends Node2D

class_name MovementTail

@export var targets: Array[Node]
@export var min_distance: int = 10000
@export var flee_distance: int = 7000
@export var speed: float = 50
@export var cant_touch_this: bool = true

var controlled_pawn: Node2D

const WORLD_MARGIN = Vector2i(32, 32)


func _ready():
    controlled_pawn = get_child(0)


func move_away(target_position: Vector2, amount: float):
    var direction: Vector2 = -global_position.direction_to(target_position)
    global_position += direction * amount
    global_position = global_position.clamp(WORLD_MARGIN, get_viewport().size - WORLD_MARGIN)


func _physics_process(delta):
    if controlled_pawn.can_move and targets:
        var min_target_distance = 100000
        var tailed_target = targets[0]
        for target in targets:
            var distance_aux = global_position.distance_squared_to(target.global_position)
            if min_target_distance > distance_aux:
                min_target_distance = distance_aux
                tailed_target = target
        var distance = global_position.distance_squared_to(tailed_target.global_position)
        if cant_touch_this and distance < min_distance:
            if distance < flee_distance:
                move_away(tailed_target.global_position, delta * speed)
            else:
                pass
        else:
            global_position = global_position.move_toward(tailed_target.global_position, delta * speed)
