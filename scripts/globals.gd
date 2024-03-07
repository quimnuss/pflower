extends Node

const SAVEFILE = "user://pflower.cfg"

var config = ConfigFile.new()

var use_particles: bool = true:
    set(new_use_particles):
        config.set_value("graphics", "use_particles", new_use_particles)
        use_particles = new_use_particles

var use_mouse: bool = true:
    set(new_use_mouse):
        config.set_value("input", "use_mouse", new_use_mouse)
        use_mouse = new_use_mouse


# Called when the node enters the scene tree for the first time.
func _ready():
    var err = config.load(SAVEFILE)
    if err != OK:
        config_init()
    load_config()
    show_config()


func config_init():
    config.set_value("graphics", "use_particles", use_particles)
    config.set_value("input", "use_mouse", use_mouse)
    config.save(SAVEFILE)


func load_config():
    use_particles = config.get_value("graphics", "use_particles", use_particles)
    use_mouse = config.get_value("input", "use_mouse", use_mouse)


func show_config():
    prints("use_particles", use_particles, "use_mouse", use_mouse)
