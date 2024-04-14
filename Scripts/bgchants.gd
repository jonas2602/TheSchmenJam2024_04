extends AudioStreamPlayer

const MAX_INT : int = 0xFFFFFFFF
const NO_KEY  : int = MAX_INT

@export var chant_remain_time : float = 0.5
var chant_player : AudioStreamPlayer
var chant_timer = 0.0

func process_chants(key, delta):
	if key == NO_KEY:
		chant_timer -= delta
		if (chant_timer < 0 && playing):
			stop()
		return
	
	if not playing:
		play()
	chant_timer = chant_remain_time

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = load("res://Data/Audio/weird_chants.ogg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # we  call process_chants from player_voice instead, maybe do somethings with  signals  instead idk
