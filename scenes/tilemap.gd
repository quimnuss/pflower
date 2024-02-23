extends TileMap

enum TileType {GROUND, WATER, GRASS}

const COOLDOWN : int = 3


var last_tile : Vector2i = Vector2i(50,50)

var unstable_tiles : Dictionary

func set_tile(tile_coords : Vector2i, tile_type : TileType, timer_to_ground : bool = true):
    if last_tile == tile_coords:
        if Constants.debug:
            for t : Timer in unstable_tiles.values():
                if t:
                    print(t.wait_time)
        return
    var paint_coords : Vector2i = tile_coords
    last_tile = tile_coords
    self.set_cells_terrain_connect(1, [paint_coords], 1, tile_type, false)

    if not timer_to_ground:
        return

    var nochtile = unstable_tiles.get(paint_coords, null)
    if nochtile:
        nochtile = nochtile as Timer
        nochtile.start(COOLDOWN)
        return

    var timer : Timer = Timer.new()
    timer.one_shot = true
    timer.timeout.connect(reset_tile.bind(timer, paint_coords))
    unstable_tiles[paint_coords] = timer
    add_child(timer)
    timer.start(COOLDOWN)

func reset_tile(timer : Timer, tile_coords : Vector2i):
    if tile_coords != last_tile:
        timer.queue_free()
        unstable_tiles[tile_coords] = null
        self.set_cells_terrain_connect(1, [tile_coords], 1, TileType.GROUND, false)
    else:
        var t : Timer = unstable_tiles[tile_coords]
        if t:
            t.start(COOLDOWN)
