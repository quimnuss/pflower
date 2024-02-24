extends TileMap

class_name PfTileMap

enum TileType {GROUND, WATER, GRASS}

const COOLDOWN : int = 3

const TERRAIN_LAYER : int = 1
const TERRAIN_SET : int = 1

var last_tile : Vector2i = Vector2i(50,50)

var unstable_tiles : Dictionary

signal tile_changed(tile_coords : Vector2i, previous_tile_type : TileType, tile_type : TileType)

func set_tile_consequences(tile_coords : Vector2i, tile_type : TileType):
    pass

func add_tile_timer(tile_coords : Vector2i):
    var timer : Timer = Timer.new()
    timer.one_shot = true
    timer.timeout.connect(cooldown_timeout.bind(timer, tile_coords))
    unstable_tiles[tile_coords] = timer
    add_child(timer)
    timer.start(COOLDOWN)

func set_tile(tile_coords : Vector2i, tile_type : TileType):
    var tile_data : TileData = self.get_cell_tile_data(TERRAIN_LAYER, tile_coords)
    var previous_tile_type : TileType = tile_data.terrain
    if previous_tile_type != tile_type:
        self.set_cells_terrain_connect(TERRAIN_LAYER, [tile_coords], TERRAIN_SET, tile_type, false)
        tile_changed.emit(tile_coords, previous_tile_type, tile_type)

func try_set_tile(tile_coords : Vector2i, tile_type : TileType, timer_to_ground : bool = true):
    if last_tile == tile_coords:
        if Constants.debug:
            for t : Timer in unstable_tiles.values():
                if t:
                    print(t.wait_time)
        return
    var paint_coords : Vector2i = tile_coords
    last_tile = paint_coords
    set_tile_consequences(paint_coords, tile_type)
    set_tile(paint_coords, tile_type)

    if not timer_to_ground:
        return

    var nochtile = unstable_tiles.get(paint_coords, null)
    if nochtile:
        nochtile = nochtile as Timer
        nochtile.start(COOLDOWN)
        return
    else:
        add_tile_timer(paint_coords)

func reset_tile(timer : Timer, tile_coords : Vector2i):
    timer.queue_free()
    unstable_tiles[tile_coords] = null
    set_tile(tile_coords, TileType.GROUND)

func tile_sinergy(sinergy_type : TileType, tile_coords : Vector2i) -> bool:
    for cell : Vector2i in self.get_surrounding_cells(tile_coords):
        var neighbour_tile_data : TileData = self.get_cell_tile_data(TERRAIN_LAYER, cell)
        if sinergy_type == neighbour_tile_data.terrain:
            return true
    return false

func check_tile_survival(tile_coords : Vector2i) -> bool:
    var dying_tile_data : TileData = self.get_cell_tile_data(TERRAIN_LAYER, tile_coords)

    var has_sinergy : bool = false

    match dying_tile_data.terrain:
        TileType.GROUND:
            push_error("Undieable tile type",tile_coords,"type",dying_tile_data.terrain)
            return false
        TileType.GRASS:
            has_sinergy = tile_sinergy(TileType.WATER, tile_coords)
        TileType.WATER:
            has_sinergy = tile_sinergy(TileType.GRASS, tile_coords)

    return has_sinergy

func cooldown_timeout(timer : Timer, tile_coords : Vector2i):
    # check that the player moved
    if tile_coords != last_tile:
        var has_sinergy : bool = check_tile_survival(tile_coords)
        if not has_sinergy:
            reset_tile(timer, tile_coords)
    else:
        var t : Timer = unstable_tiles[tile_coords]
        if t:
            t.start(COOLDOWN)
