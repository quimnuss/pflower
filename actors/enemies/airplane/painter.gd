extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $PaintArea2D/CollisionShape2D


func trigger():
    self.visible = true
    animated_sprite_2d.play("delivery")


func _on_animated_sprite_2d_animation_finished():
    match animated_sprite_2d.animation:
        "delivery":
            animated_sprite_2d.play("paint")
            collision_shape_2d.disabled = false
        "stop":
            self.visible = false


func stop():
    animated_sprite_2d.play("stop")
    collision_shape_2d.disabled = true


func _on_paint_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
    if body is PfTileMap:
        var collided_tilemap = body as PfTileMap
        var tile_coords = collided_tilemap.get_coords_for_body_rid(body_rid)
        collided_tilemap.set_tile(tile_coords, PfTileMap.TileType.GROUND)
