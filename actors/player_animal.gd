extends CharacterBody2D

class_name Animal

enum Species { NONE, BEAR, FOX, BOAR, WOLF, STAG, DOE, BIRD, FISH }

const species_name: Dictionary = {
    Species.NONE: "",
    Species.BEAR: "bear",
    Species.FOX: "fox",
    Species.BOAR: "boar",
    Species.WOLF: "wolf",
    Species.STAG: "stag",
    Species.DOE: "doe",
    Species.BIRD: "bird",
    Species.FISH: "fish"
}

var speed = 200.0
var acceleration = 100.0
const JUMP_VELOCITY = -400.0
const MOVING_THRESHOLD = 0.05
const WAIT_FOR_KILLER_TIMEOUT = 6

@export var tile_type = 1

@export var resource: LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@export var mouse_movement: bool = false

@onready var state_machine = $StateChart
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var highlight = $Highlight
@onready var terrain_transform_collision = $Area2D/CollisionShape2D
@onready var dash_hitbox_collision = $DashHitbox/CollisionShape2D

var player_controlled: bool = true

@export var player_suffix: String = Globals.KEYBOARD_0

signal dying
signal hit


static func New(_resource: Resource) -> Animal:
    var player: Animal = Animal.new()
    from_resource(player, _resource)
    return player


static func from_resource(player: Animal, _resource: Resource):
    player.resource = _resource
    player.set_name.call_deferred(_resource.name)
    player.set_scale(Vector2(_resource.scale, _resource.scale))
    player.speed = _resource.speed

    if _resource.mobility_type == "fly":
        player.set_collision_mask_value(2, false)


static func from_settings(player_data: PlayerData) -> Animal:
    var species: Species = player_data.species
    var _player_suffix: String = player_data.player_suffix

    if species == Species.NONE:
        push_error("Instantiating NONE animal species")
        return null
    var player: Animal = load("res://actors/player_animal.tscn").instantiate()
    var _resource: Resource = load("res://data/lifeform_" + species_name[species] + ".tres")
    from_resource(player, _resource)
    player.tile_type = player_data.skill
    if _player_suffix == "mouse_0":
        player.mouse_movement = true
        player.player_suffix = _player_suffix
    else:
        player.player_suffix = _player_suffix
    player.mouse_movement = player_data.mouse_movement

    return player


func _ready():
    if get_parent() == get_tree().root:
        print("I'm the main scene.")

    # TODO when instantiated this has already been done
    Animal.from_resource(self, resource)

    sprite.set_texture(resource.texture)
    sprite.hframes = resource.texture_shape[0]
    sprite.vframes = resource.texture_shape[1]
    prints(resource.name, "animation library", resource.animation_library.get_animation_list())
    for library in animation_player.get_animation_library_list():
        animation_player.remove_animation_library(library)
    animation_player.add_animation_library("animal", resource.animation_library)

    $StateChartDebugger.visible = false


func _input(event):
    if player_controlled:
        if event.is_action_pressed("switch_skill_" + player_suffix) or mouse_movement and event is InputEventMouseButton and event.double_click:
            tile_type = (tile_type + 1) % 2

        elif event.is_action_pressed("jump_" + player_suffix) or mouse_movement and event is InputEventMouseButton and not event.double_click:
            state_machine.send_event("jump")


func stop():
    velocity = Vector2(0, 0)


func _physics_input_process(_delta):
    if player_controlled:
        var input_direction: Vector2
        if mouse_movement:
            if global_position.distance_to(get_global_mouse_position()) > 5:
                input_direction = (get_global_mouse_position() - global_position).normalized()
        else:
            input_direction = Input.get_vector(
                "move_left_" + player_suffix, "move_right_" + player_suffix, "move_up_" + player_suffix, "move_down_" + player_suffix
            )

        var final_speed: float = speed

        if input_direction:
            velocity = Vector2(final_speed, final_speed) * input_direction
            #velocity = velocity.move_toward(Vector2(speed,speed)*input_direction, delta * speed)
        else:  # stop
            stop()
            #velocity = velocity.move_toward(Vector2(0,0), delta*speed)

    # this logic should be in the state machine somehow
    if velocity.x < -0.03:
        sprite.set_flip_h(true)
        #self.set_scale(Vector2(-1, 1))
    elif velocity.x > 0.03:
        sprite.set_flip_h(false)
        #self.set_scale(Vector2(-1, 1))

    move_and_slide()


func _on_run_anim_state_physics_processing(delta):
    _physics_input_process(delta)
    if velocity.length_squared() <= MOVING_THRESHOLD:
        state_machine.send_event("stopped")
    else:
        #prints("velocity",self.name,velocity.length_squared())
        pass


func _on_idle_anim_state_physics_processing(delta):
    _physics_input_process(delta)
    if not velocity.length_squared() <= MOVING_THRESHOLD:
        state_machine.send_event("is_moving")


func _process_tile_enter(collided_tilemap: PfTileMap, body_rid: RID) -> void:
    var entered_tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)

    var tile_data: TileData = collided_tilemap.get_cell_tile_data(PfTileMap.TERRAIN_LAYER, entered_tile_coords)

    var collided_tile_terrain: PfTileMap.TileType = tile_data.terrain as PfTileMap.TileType
    var new_terrain: PfTileMap.TileType = (1 + tile_type) as PfTileMap.TileType
    if collided_tile_terrain != new_terrain:
        collided_tilemap.set_tile(entered_tile_coords, 1 + tile_type)
    collided_tilemap.invalidate_timer(entered_tile_coords)


func _process_tile_exit(collided_tilemap: PfTileMap, body_rid: RID) -> void:
    var exit_tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)

    var tile_data: TileData = collided_tilemap.get_cell_tile_data(PfTileMap.TERRAIN_LAYER, exit_tile_coords)

    var collided_tile_terrain: PfTileMap.TileType = tile_data.terrain as PfTileMap.TileType

    if collided_tile_terrain != PfTileMap.TileType.GROUND:
        collided_tilemap.cooldown_tile(exit_tile_coords)


func _on_area_2d_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
    if body is PfTileMap:
        _process_tile_enter(body, body_rid)


func _on_area_2d_body_shape_exited(body_rid, body, _body_shape_index, _local_shape_index):
    if body is PfTileMap:
        _process_tile_exit(body, body_rid)


func set_terrain_transform(activate: bool):
    terrain_transform_collision.disabled = not activate


func die():
    state_machine.send_event("death")


var jump_multiplier: float = 3


func _on_jump_anim_state_entered():
    speed = jump_multiplier * speed
    dash_hitbox_collision.disabled = false
    $Ghost.set_process(true)
    $Sprite2D.modulate = Color(10, 10, 10, 0.4)
    await get_tree().create_timer(0.30).timeout
    $Sprite2D.modulate = Color(1, 1, 1, 1)
    $Ghost.set_process(false)
    speed = int(speed / jump_multiplier)
    dash_hitbox_collision.disabled = true


func _on_jump_anim_state_exited():
    #speed = int(speed / jump_multiplier)
    pass


func _on_jump_anim_state_physics_processing(delta):
    _physics_input_process(delta)


func _on_death_anim_state_entered():
    hit.emit()
