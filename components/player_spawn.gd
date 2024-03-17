extends Marker2D


func _ready():
    if not Globals.players:
        var player_data: PlayerData = PlayerData.New(Animal.Species.BEAR, Globals.KEYBOARD_0, false, 0)
        Globals.players.append(player_data)
        var player_data2: PlayerData = PlayerData.New(Animal.Species.FOX, "keyboard_1", true, 1)
        Globals.players.append(player_data2)

    var animals: Array[Animal] = Globals.load_players()
    var offset: int = 30
    var count: int = 0
    for animal: Animal in animals:
        prints("animal spawn position", animal.global_position + Vector2(count * offset, 0))
        self.add_child(animal)
        count += 1
    if not animals:
        push_error("Failed loading players" + str(Globals.players))
