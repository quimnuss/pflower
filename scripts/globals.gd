extends Node

const SAVEFILE = "user://pflower.cfg"

const PLAYERS_GROUP = "players"

const KEYBOARD: String = "keyboard"
const MOUSE: String = "mouse"
const JOY: String = "joy"

const MOUSE_0: String = "mouse_0"
const KEYBOARD_0: String = "keyboard_0"
const KEYBOARD_1: String = "keyboard_1"

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

var language_code: String = "en":
    set(new_language_code):
        config.set_value("gameplay", "language", new_language_code)
        language_code = new_language_code
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
    config.set_value("gameplay", "language_code", language_code)
    config.save(SAVEFILE)


func load_config():
    use_particles = config.get_value("graphics", "use_particles", use_particles)
    hard_difficulty = config.get_value("gameplay", "hard_difficulty", hard_difficulty)
    language_code = config.get_value("gameplay", "language_code", language_code)
    TranslationServer.set_locale(language_code)


func show_config():
    prints("use_particles", use_particles, "hard_difficulty", hard_difficulty, "language_code", language_code)


func add_player(player_data: PlayerData):
    players.append(player_data)


func load_players(spawn_position: Vector2 = Vector2i(0, 0)) -> Array[Animal]:
    var animals: Array[Animal] = []
    var player_count: int = 0
    for player_data in self.players:
        var player_animal: Animal = Animal.from_settings(player_data)
        player_animal.global_position = spawn_position + Vector2(player_count * 75, 0)
        player_count += 1
        animals.append(player_animal)
        player_animal.add_to_group(PLAYERS_GROUP)
    return animals
