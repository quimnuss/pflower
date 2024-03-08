extends Node2D

class_name Foot

@onready var boot = $BootSprite2D
@onready var stomp_audio = $stomp_audio
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var shadow_sprite_2d = $ShadowSprite2D

var speed = 1800

var is_root_scene = false

var do_stomp = false
var stomp_ended = false

signal stomped


# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group("enemies")
    is_root_scene = self == get_tree().current_scene
    if is_root_scene:
        self.global_position = Vector2i(300, 400)
    set_process(false)
    await get_tree().create_timer(3).timeout
    print("stomp")
    set_process(true)
    collision_shape_2d.disabled = true


func _on_game_won():
    smoke()
    collision_shape_2d.disabled = false
    await get_tree().create_timer(5).timeout
    self.queue_free()


func smoke():
    if Globals.use_particles:
        var smoke = load("res://components/explosion.tscn").instantiate()
        shadow_sprite_2d.add_child(smoke)


func stomp_end():
    stomp_ended = true
    stomp_audio.play()
    stomped.emit()
    smoke()
    collision_shape_2d.disabled = false
    await get_tree().create_timer(5).timeout
    self.queue_free()


func stomp(delta):
    if boot.position.y < 0:
        boot.position.y = min(boot.position.y + speed * delta, 0)
    elif not stomp_ended:
        stomp_end()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if is_root_scene:
        if Input.is_action_pressed("jump_0"):
            do_stomp = true
        if do_stomp and not stomp_ended:
            stomp(delta)
    else:
        if not stomp_ended:
            stomp(delta)


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
    if body is PfTileMap:
        var collided_tilemap = body as PfTileMap
        var tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)
        collided_tilemap.set_tile(tile_coords, PfTileMap.TileType.GROUND)
    elif stomp_ended and body is Animal:
        body.die()
