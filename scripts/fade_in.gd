extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
    var tween = get_tree().create_tween()
    self.modulate.a = 0
    tween.tween_property(self, "modulate:a", 1, 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
