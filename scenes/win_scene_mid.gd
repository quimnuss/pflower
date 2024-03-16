extends CanvasLayer

@onready var texture_rect = $Control/MarginContainer/VBoxContainer/Control/TextureRect
@onready var label = $Control/MarginContainer/VBoxContainer/Label
@onready var control = $Control
@onready var restored_label = $Control/MarginContainer/VBoxContainer/RestoredLabel

@export var fillup_curve: Curve

const ANIMATION_DURATION: float = 3

var step = 0
var animation_progress: float = 0


func _ready():
    self.set_process(false)
    texture_rect.visible = false
    restored_label.modulate = Color(1, 1, 1, 0)


func _process(delta):
    animation_progress += delta / ANIMATION_DURATION
    animation_progress = clamp(animation_progress, 0, 1)

    if step == 0:
        var progress: float = fillup_curve.sample(animation_progress)
        label.text = str(round(progress * 100)) + "%"
        if animation_progress >= 1:
            step = 1
            animation_progress = 0
            restored_label.modulate = Color(1, 1, 1, 1)
            texture_rect.visible = true
    elif step == 1:
        # wait 3 seconds
        if animation_progress >= 1:
            step = 2
            animation_progress = 0
    elif step == 2:
        control.set_modulate(lerp(control.get_modulate(), Color(1, 1, 1, 0), animation_progress))
        if animation_progress >= 1:
            step = 2
    else:
        queue_free()


func _on_restoration_game_restoration_complete():
    self.visible = true
    self.set_process(true)
