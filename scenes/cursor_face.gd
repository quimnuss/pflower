extends Sprite2D

var tile_timers: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
    pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    global_position = get_viewport().get_mouse_position()


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
    if body is PfTileMap:
        var collided_tilemap = body as PfTileMap
        var tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)
        var tile_data: TileData = collided_tilemap.get_cell_tile_data(PfTileMap.TERRAIN_LAYER, tile_coords)
        collided_tilemap.set_cells_terrain_connect(PfTileMap.TERRAIN_LAYER, [tile_coords], PfTileMap.TERRAIN_SET, PfTileMap.TileType.GRASS, false)
        prints("entered", tile_coords, "of terrain type", tile_data.terrain, "set to", PfTileMap.TileType.GRASS)


func ground_tile(collided_tilemap: PfTileMap, timer: Timer, tile_coords: Vector2i):
    collided_tilemap.set_cells_terrain_connect(PfTileMap.TERRAIN_LAYER, [tile_coords], PfTileMap.TERRAIN_SET, PfTileMap.TileType.GROUND, false)


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
    if body is PfTileMap:
        var collided_tilemap = body as PfTileMap
        var tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)
        var tile_data: TileData = collided_tilemap.get_cell_tile_data(PfTileMap.TERRAIN_LAYER, tile_coords)
        prints("exited", tile_coords, "of terrain type", tile_data.terrain)
        if tile_data.terrain == PfTileMap.TileType.GRASS:
            var timer: Timer = Timer.new()
            timer.one_shot = true
            timer.timeout.connect(ground_tile.bind(timer, tile_coords))
            tile_timers[tile_coords].timeout.connect(collided_tilemap, ground_tile, tile_coords)
