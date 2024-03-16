extends Resource

class_name PlayerData

var species: Animal.Species = Animal.Species.BEAR

var player_suffix: String = Globals.KEYBOARD_0

var mouse_movement: bool = true

var skill: int = 0


static func New(_species: Animal.Species, _player_suffix: String, _mouse_movement: bool, _skill: int) -> PlayerData:
    var player_data: PlayerData = PlayerData.new()
    player_data.species = _species
    player_data.player_suffix = _player_suffix
    player_data.mouse_movement = _mouse_movement
    player_data.skill = _skill
    return player_data
