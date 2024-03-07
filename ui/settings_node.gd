extends Node2D

@export var setting_text: String = ""
@export var setting_change: Callable
@onready var label = $Label


func _ready():
    label.text = setting_text


func activate(is_activated: bool):
    if is_activated:
        label.set("theme_override_colors/font_color", Color(1, 1, 1, 1))
    else:
        label.set("theme_override_colors/font_color", Color(0.5, 0.5, 0.5, 1))


func _on_area_2d_body_entered(body):
    var is_activated: bool = setting_change.call()
    activate(is_activated)
