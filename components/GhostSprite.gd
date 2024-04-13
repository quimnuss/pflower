extends Sprite2D

class_name GhostSprite


static func Instance(animated_sprite: AnimatedSprite2D):
    var frame_index: int = animated_sprite.get_frame()
    var sprite_frames: SpriteFrames = animated_sprite.get_sprite_frames()
    var current_texture: Texture2D = sprite_frames.get_frame_texture(animated_sprite.animation, frame_index)
    var ghost_scene = preload("res://components/GhostSprite.tscn").instantiate()
    ghost_scene.global_position = animated_sprite.global_position
    ghost_scene.texture = current_texture


func _ready():
    var tween = get_tree().create_tween()
    tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
    tween.start()
