extends Node

const SAVEFILE = "user://pflower.cfg"

var config = ConfigFile.new()

var use_particles: bool = true:
    set(new_use_particles):
        config.set_value("graphics", "use_particles", new_use_particles)
        use_particles = new_use_particles
        config.save(SAVEFILE)

var hard_difficulty: bool = false:
    set(new_hard_difficulty):
        config.set_value("gameplay", "hard_difficulty", new_hard_difficulty)
        hard_difficulty = new_hard_difficulty
        config.save(SAVEFILE)

var players: Array[PlayerData] = []


# Called when the node enters the scene tree for the first time.
func _ready():
    var err = config.load(SAVEFILE)
    if err != OK:
        config_init()
    load_config()
    show_config()


func config_init():
    config.set_value("graphics", "use_particles", use_particles)
    config.set_value("gameplay", "hard_difficulty", hard_difficulty)
    config.save(SAVEFILE)


func load_config():
    use_particles = config.get_value("graphics", "use_particles", use_particles)
    hard_difficulty = config.get_value("gameplay", "hard_difficulty", hard_difficulty)


func show_config():
    prints("use_particles", use_particles, "hard_difficulty", hard_difficulty)


func add_player(player_data: PlayerData):
    players.append(player_data)


func load_players(spawn_position: Vector2) -> Array[Animal]:
    var animals: Array[Animal] = []
    var player_count: int = 0
    for player_data in self.players:
        var player_animal: Animal = Animal.from_settings(player_data)
        player_animal.global_position = spawn_position + Vector2(player_count * 75, 0)
        player_count += 1
        animals.append(player_animal)
        player_animal.add_to_group("players")
    return animals
