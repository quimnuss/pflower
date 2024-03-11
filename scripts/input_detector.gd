extends Node2D

var player_inputs: Array

signal new_player(device_type: String, device_num: int)


func _input(event):
    if event is InputEventKey:
        var player_side = 0
        if event.as_text_keycode().to_lower() in ["h", "j", "k", "u"]:
            player_side = 1
        var device_num = player_inputs.find("keyboard_" + str(player_side))
        if device_num < 0:
            player_inputs.append("keyboard_" + str(player_side))
            new_player.emit("keyboard", player_side)
    elif event is InputEventMouseButton:
        var device_num = player_inputs.find("mouse")
        if device_num < 0:
            player_inputs.append("mouse")
            new_player.emit("mouse", 0)
    elif event is InputEventJoypadButton:
        event.get_rid()
        var device_num = player_inputs.find("joy" + str(event.device))
        if device_num < 0:
            player_inputs.append("joy" + str(event.device))
            new_player.emit("joy", event.device)
