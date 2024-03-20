extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
    var anima = Anima.New(self).anima_fade_in(10)

    anima.play()
