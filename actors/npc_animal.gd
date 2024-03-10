extends CharacterBody2D

class_name NPCAnimal

var speed = 200.0
var acceleration = 100.0

@export var resource: LifeformAnimalResource = preload("res://data/lifeform_bear.tres")

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D


static func New(_resource: Resource) -> NPCAnimal:
    var npc: NPCAnimal = NPCAnimal.new()
    from_resource(npc, _resource)
    return npc


static func from_resource(npc: NPCAnimal, _resource: Resource):
    npc.set_name.call_deferred(_resource.name)
    npc.set_scale(Vector2(_resource.scale, _resource.scale))
    npc.speed = _resource.speed

    if _resource.mobility_type == "fly":
        npc.set_collision_mask_value(2, false)


func _ready():
    NPCAnimal.from_resource(self, resource)

    if get_parent() == get_tree().root:
        print("I'm the main scene.")

    sprite.set_texture(resource.texture)
    sprite.hframes = resource.texture_shape[0]
    sprite.vframes = resource.texture_shape[1]
    prints(resource.name, "animation library", resource.animation_library.get_animation_list())
    for library in animation_player.get_animation_library_list():
        animation_player.remove_animation_library(library)
    animation_player.add_animation_library("animal", resource.animation_library)

    animation_player.play("animal/idle")
