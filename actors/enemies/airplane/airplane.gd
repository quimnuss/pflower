extends Node2D

@onready var animation_player = $Hit/AnimationPlayer
@onready var trigger_timer: Timer = $TriggerTimer
@onready var painter_node_2d = $PainterNode2D
@onready var label = $Label
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var speed = 70

var direction = Vector2(0, 1)
var is_debug: bool

var is_blinking: bool = false
var elapsed: float = 0
var blink_on: int = 0


func _ready():
    is_debug = OS.is_debug_build() and self == get_tree().current_scene
    if is_debug:
        self.global_position = Vector2i(300, 300)
        label.visible = true
    else:
        label.visible = false

    painter_node_2d.visible = false

    var players = get_tree().get_nodes_in_group("players")
    var target = players.pick_random() if players else null
    if target:
        look_at(target.global_position)


func _process(delta):
    if global_position < Vector2(-200, -200) or Vector2(1200, 1200) < global_position:
        queue_free()

    var timer: Timer = $WarningTimer if not $WarningTimer.is_stopped() else $TriggerTimer
    label.set_text(str(roundi(timer.time_left)))

    elapsed += delta
    if is_blinking and fmod(elapsed, 2) != blink_on:
        blink_on = fmod(elapsed, 2) as int
        blink_status(blink_on)


func blink_status(on: bool):
    if on:
        var red = Color(1.0, 0.0, 0.0, 1.0)
        label.set("theme_override_colors/font_color", red)
        animated_sprite_2d.modulate = Color(1, 1, 1, 1)
    else:
        label.set("theme_override_colors/font_color", Color(1, 1, 1, 1))
        animated_sprite_2d.modulate = Color(0, 1, 0.5, 1)


func _physics_process(delta):
    position += delta * Vector2(speed, 0).rotated(rotation)


func _input(event):
    if is_debug:
        look_at(get_global_mouse_position())
        if event is InputEventMouseButton:
            hit()


func hit():
    animation_player.play("hit")


func start_warning():
    is_blinking = true


func stop():
    painter_node_2d.stop()
    is_blinking = false
    blink_status(false)


func trigger():
    painter_node_2d.trigger()
    is_blinking = false
    blink_status(true)
    await get_tree().create_timer(4).timeout
    stop()


func _on_area_2d_body_entered(body):
    print(body)
    if body is Animal:
        hit()


func _on_animation_player_animation_finished(anim_name):
    match anim_name:
        "hit":
            queue_free()


func _on_hurt_box_area_entered(_area):
    hit()


func _on_visible_on_screen_notifier_2d_screen_entered():
    if not $WarningTimer.is_paused() and $WarningTimer.is_stopped():
        $WarningTimer.start()


func _on_trigger_timer_timeout():
    trigger()


func _on_warning_timer_timeout():
    start_warning()
    $WarningTimer.paused = true
    $TriggerTimer.start()
