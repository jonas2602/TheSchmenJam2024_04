extends AudioStreamPlayer

const MAX_INT : int = 0xFFFFFFFF
const NO_KEY  : int = MAX_INT

@export var chant_remain_time : float = 0.556
var chant_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = load("res://Data/Audio/weird_chants.ogg")
	GlobalEventSystem.input_detected.connect(_on_input_detected)

func _on_input_detected(input_char : String):
	chant_timer = chant_remain_time
	if not playing:
		play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chant_timer -= delta
	pass
