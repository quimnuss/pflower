extends Marker2D


func _ready():
    if not Globals.players:
        var player_data: PlayerData = PlayerData.New(Animal.Species.BEAR, Globals.KEYBOARD_0, false, 0)
        Globals.players.append(player_data)

    var animals: Array[Animal] = Globals.load_players()
    for animal: Animal in animals:
        prints("animal spawn position", animal.global_position)
        self.add_child(animal)
    if not animals:
        push_error("Failed loading players" + str(Globals.players))
