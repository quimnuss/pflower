extends Sprite2D

class_name GhostSprite


func _ready():
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
    tween.play()
    tween.finished.connect(destroy)


func destroy():
    queue_free()


static func Instance(sprite: Sprite2D) -> GhostSprite:
    var ghost_scene = load("res://components/ghost_sprite.tscn").instantiate()
    ghost_scene.global_position = sprite.global_position
    ghost_scene.texture = sprite.texture
    ghost_scene.vframes = sprite.vframes
    ghost_scene.hframes = sprite.hframes
    ghost_scene.frame = sprite.frame
    ghost_scene.flip_h = sprite.flip_h
    ghost_scene.scale = sprite.scale
    #ghost_scene.transform = sprite.transform
    return ghost_scene