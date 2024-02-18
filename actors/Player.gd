extends CharacterBody2D


const speed = 300.0


func _physics_process(delta):
    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if input_direction:
        velocity = velocity.move_toward(Vector2(speed,speed)*input_direction, delta * speed)
    else: # stop
        velocity = velocity.move_toward(Vector2(0,0), delta*speed)
    move_and_slide()
