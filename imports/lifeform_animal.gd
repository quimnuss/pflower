extends CharacterBody2D

class_name Animal

var speed = 200.0
var acceleration = 100.0
const JUMP_VELOCITY = -400.0
const MOVING_THRESHOLD = 0.05
const WAIT_FOR_KILLER_TIMEOUT = 6

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var resource : LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var state_machine = $StateChart
@onready var movement = $Movement
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var highlight = $Highlight



signal selected
signal dying


var debug = false

#TODO handle unselectable spawn
var is_selected = false

var sensed_predators : Array[Animal] = []
var predator_sensed_count = 0

static func New(resource : Resource):
    var player : Animal = Animal.new()
    player.set_name.call_deferred(resource.name)
    player.set_scale(Vector2(resource.scale,resource.scale))
    player.speed = resource.speed
    player.species = resource.species


func _ready():

    if resource.mobility_type == 'fly':
        self.set_collision_mask_value(2,false)
    sprite.set_texture(resource.texture)
    sprite.hframes = resource.texture_shape[0]
    sprite.vframes = resource.texture_shape[1]
    prints(resource.name,"animation library",resource.animation_library.get_animation_list())
    for library in animation_player.get_animation_library_list():
        animation_player.remove_animation_library(library)
    animation_player.add_animation_library("animal",resource.animation_library)

    movement.pawn = self
    $StateChartDebugger.visible = false
    input_pickable = true

    if get_parent() == get_tree().root:
        $NavigationRegion2D.set_enabled(true)
        set_selected(true)
    else:
        set_selected(false)


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

func set_target_lifeform(target_lifeform : Node2D):
    self.movement.target_lifeform = target_lifeform

func set_selected(turn_on):
    set_highlight(turn_on)
    is_selected = turn_on
    if is_selected:
        state_machine.send_event("posess")
    else:
        state_machine.send_event("unposess")
    # how to deal with deselect on click?
        selected.emit(self)

func get_selected():
    return is_selected

func set_highlight(turn_on = true, blueish = false):
    highlight.visible = turn_on
    if blueish:
        highlight.modulate = Color(0, 0, 1) # blue shade

func _on_idle_state_entered():
    state_machine.set_expression_property("predator_sensed_count", predator_sensed_count)

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

