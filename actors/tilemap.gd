extends TileMap

class_name PfTileMap

enum TileType { GROUND, WATER, GRASS }

const COOLDOWN: int = 3

const TERRAIN_LAYER: int = 1
const TERRAIN_SET: int = 1

#var last_tile: Vector2i = Vector2i(50, 50)

var unstable_tiles: Dictionary

signal tile_changed(tile_coords: Vector2i, previous_tile_type: TileType, tile_type: TileType)


func set_tile_consequences(tile_coords: Vector2i, tile_type: TileType):
    pass


func cooldown_tile(tile_coords: Vector2i):
    var nochtile = unstable_tiles.get(tile_coords, null)
    if nochtile:
        nochtile = nochtile as Timer
        nochtile.start(COOLDOWN)
        return
    else:
        add_tile_timer(tile_coords)


func add_tile_timer(tile_coords: Vector2i):
    var timer: Timer = Timer.new()
    timer.one_shot = true
    timer.timeout.connect(cooldown_timeout.bind(timer, tile_coords))
    unstable_tiles[tile_coords] = timer
    add_child(timer)
    timer.start(COOLDOWN)


func set_tile(tile_coords: Vector2i, tile_type: TileType):
    var tile_data: TileData = self.get_cell_tile_data(TERRAIN_LAYER, tile_coords)
    var previous_tile_type: TileType = tile_data.terrain  #if tile_data else TileType.GROUND
    if previous_tile_type != tile_type:  # or not tile_data:
        self.set_cells_terrain_connect(TERRAIN_LAYER, [tile_coords], TERRAIN_SET, tile_type, false)
        tile_changed.emit(tile_coords, previous_tile_type, tile_type)


func reset_tile(timer: Timer, tile_coords: Vector2i):
    timer.queue_free()
    unstable_tiles[tile_coords] = null
    set_tile(tile_coords, TileType.GROUND)


func invalidate_timer(tile_coords: Vector2i):
    var tile_timer: Timer = unstable_tiles.get(tile_coords)
    if tile_timer:
        tile_timer.stop()
        unstable_tiles[tile_coords] = null
        tile_timer.queue_free()


func get_near_cells(tile_coords: Vector2i):
    var TILE_DISTANCE: int = 2
    var near_cells: Array[Vector2i] = []
    for dx in range(-TILE_DISTANCE, TILE_DISTANCE + 1):
        for dy in range(-TILE_DISTANCE, TILE_DISTANCE + 1):
            var cell_coords: Vector2i = tile_coords + Vector2i(dx, dy)
            # TODO check out of map
            near_cells.append(cell_coords)
    return near_cells


func tile_sinergy(sinergy_type: TileType, tile_coords: Vector2i) -> bool:
    for cell: Vector2i in self.get_near_cells(tile_coords):
        var neighbour_tile_data: TileData = self.get_cell_tile_data(TERRAIN_LAYER, cell)
        if neighbour_tile_data and sinergy_type == neighbour_tile_data.terrain:
            return true
    return false


func check_tile_survival(tile_coords: Vector2i) -> bool:
    var dying_tile_data: TileData = self.get_cell_tile_data(TERRAIN_LAYER, tile_coords)

    var has_sinergy: bool = false

    match dying_tile_data.terrain:
        TileType.GROUND:
            #push_error("Undieable tile type ", tile_coords, " terrain type ", dying_tile_data.terrain)
            return false
        TileType.GRASS:
            has_sinergy = tile_sinergy(TileType.WATER, tile_coords)
        TileType.WATER:
            has_sinergy = tile_sinergy(TileType.GRASS, tile_coords)

    return has_sinergy


func cooldown_timeout(timer: Timer, tile_coords: Vector2i):
    var has_sinergy: bool = check_tile_survival(tile_coords)
    if not has_sinergy:
        reset_tile(timer, tile_coords)
