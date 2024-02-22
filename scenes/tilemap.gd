extends TileMap

enum TileType {GROUND, WATER, GRASS}

const COOLDOWN : int = 3

var timers : Array

var last_tile : Vector2i = Vector2i(-1,-1)

var unstable_tiles : Dictionary

func set_tile(tile_coords : Vector2i, tile_type : TileType, timer_to_ground : bool = true):
    if last_tile == tile_coords:
        return
    var nochtile = unstable_tiles.get(tile_coords, null)
    if nochtile:
        nochtile = nochtile as Timer
        self.set_cells_terrain_connect(1, [tile_coords], 1, tile_type, false)
        nochtile.start(COOLDOWN)     
        return
    last_tile = tile_coords
    self.set_cells_terrain_connect(1, [tile_coords], 1, tile_type, false)
    var timer : Timer = Timer.new()
    timer.one_shot = true
    timer.autostart = true
    timer.timeout.connect(reset_tile.bind(tile_coords))
    #timers.append(timer)
    unstable_tiles[tile_coords] = timer
    add_child(timer)    
    timer.start(COOLDOWN)

func reset_tile(tile_coords : Vector2i):
    if tile_coords != last_tile:
        unstable_tiles[tile_coords] = null
        self.set_cells_terrain_connect(1, [tile_coords], 1, TileType.GROUND, false)
