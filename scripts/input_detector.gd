extends Node2D

var player_inputs: Array

var available_inputs: Dictionary = {Globals.MOUSE: "➊", Globals.KEYBOARD_0: "Ｗ", Globals.KEYBOARD_1: "Ｈ", Globals.JOY: "⇓"}

signal new_player(device_type: String, device_num: int)


func _input(event):
    if event is InputEventKey:
        var player_side = 0
        if event.as_text_keycode().to_lower() in ["h", "j", "k", "u"]:
            player_side = 1
            available_inputs.erase(Globals.KEYBOARD_1)
        else:
            available_inputs.erase(Globals.KEYBOARD_0)
        var device_num = player_inputs.find(Globals.KEYBOARD + "_" + str(player_side))
        if device_num < 0:
            player_inputs.append(Globals.KEYBOARD + "_" + str(player_side))
            new_player.emit(Globals.KEYBOARD, player_side)
    elif event is InputEventMouseButton:
        var device_num = player_inputs.find(Globals.MOUSE)
        if device_num < 0:
            available_inputs.erase(Globals.MOUSE)
            player_inputs.append(Globals.MOUSE)
            new_player.emit(Globals.MOUSE, 0)
    elif event is InputEventJoypadButton:
        event.get_rid()
        var device_num = player_inputs.find(Globals.JOY + "_" + str(event.device))
        if device_num < 0:
            player_inputs.append(Globals.JOY + "_" + str(event.device))
            new_player.emit(Globals.JOY, event.device)
