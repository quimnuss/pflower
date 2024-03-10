extends Camera2D

@export var tile_map : TileMap

@export var target: Node2D
const MARGIN: int = 100

func _ready():
    var map_limits = tile_map.get_used_rect()
    self.limit_left = 0
    self.limit_top = 0
    self.limit_right = tile_map.map_to_local(map_limits.end).x - MARGIN
    self.limit_bottom = tile_map.map_to_local(map_limits.end).y - MARGIN

func _process(delta):
    global_position = target.global_position

    
