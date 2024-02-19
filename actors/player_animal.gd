extends CharacterBody2D

class_name Animal

var speed = 200.0
var acceleration = 100.0
const JUMP_VELOCITY = -400.0
const MOVING_THRESHOLD = 0.05
const WAIT_FOR_KILLER_TIMEOUT = 6

@export var tilemap : TileMap

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var state_machine = $StateChart
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var highlight = $Highlight

signal dying

static func New(resource : Resource):
    var player : Animal = Animal.new()
    from_resource(player, resource)

static func from_resource(player : Animal, resource : Resource):
    player.set_name.call_deferred(resource.name)
    player.set_scale(Vector2(resource.scale,resource.scale))
    player.speed = resource.speed

    if resource.mobility_type == 'fly':
        player.set_collision_mask_value(2,false)

func _ready():

    from_resource(self, resource)

    if get_parent() == get_tree().root:
        print("I'm the main scene.")
    else:
        print("I'm an instance in another scene.")

    sprite.set_texture(resource.texture)
    sprite.hframes = resource.texture_shape[0]
    sprite.vframes = resource.texture_shape[1]
    prints(resource.name,"animation library",resource.animation_library.get_animation_list())
    for library in animation_player.get_animation_library_list():
        animation_player.remove_animation_library(library)
    animation_player.add_animation_library("animal",resource.animation_library)

    $StateChartDebugger.visible = false

var tile_type = 1

func _input(event):
    if event.is_action_pressed("ui_jump"):
        tile_type = (tile_type+1)%2
        prints("changed tile type",tile_type)

func _process(delta):
    var tile : Vector2i = tilemap.local_to_map(self.position)
    var tiledata : TileData = tilemap.get_cell_tile_data(1,tile)
    tilemap.set_cells_terrain_connect(1, [tile], 1, tile_type, false)

func _physics_input_process(delta):

    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if input_direction:
        #velocity = Vector2(speed,speed)*input_direction
        velocity = velocity.move_toward(Vector2(speed,speed)*input_direction, delta * speed)
    else: # stop
        #velocity = Vector2(0,0)
        velocity = velocity.move_toward(Vector2(0,0), delta*speed)

    # this logic should be in the state machine somehow
    if velocity.x < -0.01:
        sprite.set_flip_h(true)
    elif velocity.x > 0.01:
        sprite.set_flip_h(false)

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

