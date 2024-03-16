extends Control
@onready var progress_bar = $CenterContainer/HBoxContainer/ProgressBar


func set_restoration(value: float):
    progress_bar.set_value(value)


func _on_main_game_restoration(restoration_percent):
    set_restoration(restoration_percent)


func _on_restoration_changed(restoration_percent):
    set_restoration(restoration_percent)
