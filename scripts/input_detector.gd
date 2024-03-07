extends Node2D



var player_inputs : Array

signal new_player(device_type : String, device_player_num : int)

func _input(event):
    if event is InputEventKey:
        var player_side = 0
        if event.keycode in ['h', 'j', 'k', 'u']:
            player_side = 1
        var player_num = player_inputs.find("keyboard_" + str(player_side))
        if player_num < 0:
            player_inputs.append("keyboard_" + str(player_side))
            new_player.emit("keyboard", player_side)
    elif event is InputEventMouseButton:
        var player_num = player_inputs.find("mouse")
        if player_num < 0:
            player_inputs.append("mouse")
            new_player.emit("mouse", 0)
    elif event is InputEventJoypadButton:
        print(event)
        event.get_rid()
        var player_num = player_inputs.find("joy" + str(event.device))
        if player_num < 0:
            player_inputs.append("joy" + str(event.device))
            new_player.emit("joy", event.device)
