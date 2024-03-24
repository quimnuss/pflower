extends Control

@onready var health_container = $MarginContainer/HealthContainer


func _ready():
    set_health(3)


func set_health(new_health: int):
    var hearts: Array = health_container.get_children()
    new_health = clamp(new_health, 0, len(hearts))
    for i in range(len(hearts) - new_health):
        hearts[-i - 1].set_modulate(Color(0.2, 0.2, 0.2, 0.5))
