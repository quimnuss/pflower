extends Camera2D

#Based of the 3.x KidsCanCode implementation -> https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html

@export var decay := 0.8  #How quickly shaking will stop [0,1].
@export var max_offset := Vector2(10, 50)  #Maximum displacement in pixels.
@export var max_roll := 0.1  #Maximum rotation in radians (use sparingly).
@export var noise: FastNoiseLite  #The source of random values.

var noise_y = 0  #Value used to move through the noise

var trauma := 0.0  #Current shake strength
var trauma_pwr := 3  #Trauma exponent. Use [2,3]


func _ready():
    randomize()
    noise.seed = randi()


func _input(event):
    if OS.is_debug_build() and event is InputEventMouseButton:
        add_trauma()


func add_trauma(amount: float = 0.3):
    trauma = min(trauma + amount, 1.0)
    print(trauma)


func _process(delta):
    if trauma:
        trauma = max(trauma - decay * delta, 0)
        shake()
    elif offset.x != 0 or offset.y != 0 or rotation != 0:
        offset.x = lerp(offset.x, 0.0, 1)
        offset.y = lerp(offset.y, 0.0, 1)
        #lerp(rotation, 0.0, 1)


func shake():
    var amt = pow(trauma, trauma_pwr)
    noise_y += 1
    #rotation = max_roll * amt * noise.get_noise_2d(noise.seed,noise_y)
    offset.x = clamp(max_offset.x * amt * noise.get_noise_2d(noise.seed * 2, noise_y), -max_offset.x, max_offset.x)
    offset.y = clamp(max_offset.y * amt * noise.get_noise_2d(noise.seed * 3, noise_y), -max_offset.y, max_offset.y)
    #prints(trauma, amt * noise.get_noise_2d(noise.seed * 3, noise_y), offset)
