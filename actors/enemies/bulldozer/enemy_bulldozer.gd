extends CharacterBody2D

@export var tilemap: PfTileMap
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var motor = $Node2D/motor
@onready var leaves = $Node2D/leaves
@onready var respawn_timer = $RespawnTimer
@onready var collision_shape_2d = $Area2D/CollisionShape2D

signal set_ground_tile(new_position: Vector2)

var last_position: Vector2 = Vector2(-1, -1)

const speed = 100

var is_root_scene: bool = false

var can_move: bool = true

var HARD_RESPAWN_TIME: int = 3
var respawn_time: int = 6


func _ready():
    add_to_group("enemies")
    is_root_scene = self == get_tree().current_scene
    if is_root_scene:
        prints("I'm root scene")
        tilemap = PfTileMap.new()
        tilemap.tile_set = load("res://actors/pflower_tileset.tres")
        get_tree().get_root().add_child(tilemap)


func _physics_process(delta):
    if is_root_scene:
        var input_direction: Vector2 = Input.get_vector("move_left_0", "move_right_0", "move_up_0", "move_down_0")
        if input_direction:
            velocity = delta * Vector2(speed, speed) * input_direction


func flip_h(_flip_h: bool):
    animated_sprite_2d.flip_h = _flip_h


func snooze():
    self.can_move = false
    motor.stop()
    animated_sprite_2d.play("snooze")
    leaves.play()
    await animated_sprite_2d.animation_finished
    # stay a tree for respoawn_time seconds
    respawn_timer.start(respawn_time)


func respawn():
    animated_sprite_2d.play("default")
    self.can_move = true
    motor.play()


func _on_game_won():
    print("game won: disable bulldozer")
    collision_shape_2d.disabled = true
    respawn_timer.paused = true
    respawn_timer.stop()
    self.can_move = false
    motor.stop()
    var current_animation: String = animated_sprite_2d.get_animation()
    if current_animation != "snooze":
        animated_sprite_2d.play("snooze")
        leaves.play()


func _on_area_2d_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
    if body is PfTileMap:
        var collided_tilemap = body as PfTileMap
        var entered_tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)

        var tile_data: TileData = collided_tilemap.get_cell_tile_data(PfTileMap.TERRAIN_LAYER, entered_tile_coords)

        var collided_tile_terrain: PfTileMap.TileType = tile_data.terrain as PfTileMap.TileType
        if collided_tile_terrain != PfTileMap.TileType.GROUND:
            collided_tilemap.set_tile(entered_tile_coords, PfTileMap.TileType.GROUND)
    elif body is Animal:
        snooze()
