extends CanvasLayer
@onready var you_win = $VBoxContainer/AspectRatioContainer/MarginContainer/YouWin
@onready var you_lose = $VBoxContainer/AspectRatioContainer/MarginContainer/YouLose


func set_has_won(has_won: bool):
    you_win.visible = has_won
    you_lose.visible = not has_won


func _on_close_button_pressed():
    self.visible = false
