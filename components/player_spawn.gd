extends Marker2D


func _ready():
    if not Globals.players:
        var player_data: PlayerData = PlayerData.New(Animal.Species.BEAR, Globals.KEYBOARD_0, true, 0)
        var animal: Animal = Animal.from_settings(player_data)
        animal.add_to_group(Globals.PLAYERS_GROUP)
        self.add_child(animal)
    else:
        var animals: Array[Animal] = Globals.load_players(self.global_position)
        for animal: Animal in animals:
            self.add_child(animal)
