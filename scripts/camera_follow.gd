extends Camera2D
class_name PfCamera

@export var tile_map: TileMap

@export var target: Node2D
const MARGIN: int = 50


func _ready():
    set_limits()


func set_limits():
    var map_limits = tile_map.get_used_rect()
    self.limit_left = int(tile_map.map_to_local(map_limits.position).x) + MARGIN
    self.limit_top = int(tile_map.map_to_local(map_limits.position).y) + MARGIN
    self.limit_right = int(tile_map.map_to_local(map_limits.end).x) - MARGIN
    self.limit_bottom = int(tile_map.map_to_local(map_limits.end).y) - MARGIN


func _process(_delta):
    if target:
        global_position = target.global_position
