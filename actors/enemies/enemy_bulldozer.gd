extends Node2D

@export var tilemap: PfTileMap
@onready var animated_sprite_2d = $AnimatedSprite2D

signal set_ground_tile(new_position: Vector2)

var last_position: Vector2 = Vector2(-1, -1)

const speed = 100

var is_root_scene: bool = false

var can_move: bool = true


func _ready():
    is_root_scene = self == get_tree().current_scene
    if is_root_scene:
        prints("I'm root scene")
        tilemap = PfTileMap.new()
        tilemap.tile_set = load("res://actors/pflower_tileset.tres")
        get_tree().get_root().add_child(tilemap)


func _input(event):
    if event.is_action_pressed("jump_0"):
        print("started")
        $AnimatedSprite2D.play("snooze")
        await $AnimatedSprite2D.animation_finished
        print("finished")


func _process(delta):
    pass


func _physics_process(delta):
    if is_root_scene:
        var input_direction: Vector2 = Input.get_vector("move_left_0", "move_right_0", "move_up_0", "move_down_0")
        if input_direction:
            global_position = global_position + delta * Vector2(speed, speed) * input_direction


func flip_h(flip_h: bool):
    animated_sprite_2d.flip_h = flip_h


func snooze():
    self.can_move = false
    animated_sprite_2d.play("snooze")
    await animated_sprite_2d.animation_finished
    await get_tree().create_timer(3).timeout
    animated_sprite_2d.play("default")
    self.can_move = true


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
    if body is PfTileMap:
        var collided_tilemap = body as PfTileMap
        var entered_tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)

        var tile_data: TileData = collided_tilemap.get_cell_tile_data(PfTileMap.TERRAIN_LAYER, entered_tile_coords)

        var collided_tile_terrain: PfTileMap.TileType = tile_data.terrain as PfTileMap.TileType
        if collided_tile_terrain != PfTileMap.TileType.GROUND:
            collided_tilemap.set_tile(entered_tile_coords, PfTileMap.TileType.GROUND)
    elif body is Animal:
        snooze()
