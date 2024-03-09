extends Camera2D
@onready var tile_map = $"../TileMap"

@export var target: Node2D
const MARGIN: int = 100


func _ready():
    var map_limits = tile_map.get_used_rect()
    self.limit_left = 0
    self.limit_top = 0
    self.limit_right = tile_map.map_to_local(map_limits.end).x - MARGIN
    self.limit_bottom = tile_map.map_to_local(map_limits.end).y - MARGIN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    global_position = target.global_position
    var mouse_pos: Vector2 = get_global_mouse_position()
    self.offset = (mouse_pos - global_position) / ((get_viewport().size as Vector2) / 2.0)
