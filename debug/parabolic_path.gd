extends Node2D

@export var destination: Node2D
@onready var path_follow_2d = $PathFollow2D

@export var duration: float = 3

@export var velocity_profile: Curve

var elapsed: float = 0


func _ready():
    pass


func reset():
    elapsed = 0
    path_follow_2d.progress_ratio = 0


func _physics_process(delta):
    elapsed += delta
    for child in path_follow_2d.get_children():
        path_follow_2d.progress_ratio += velocity_profile.sample(elapsed / duration)
