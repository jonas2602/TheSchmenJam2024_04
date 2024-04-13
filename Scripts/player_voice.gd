extends Node

const MAX_INT : int = 0xFFFFFFFF
const NO_KEY  : int = MAX_INT

var streams = {}

var player : AudioStreamPlayer

func load_sounds():
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for k in range(KEY_A, KEY_Z+1):
		streams[k] = ResourceLoader.load("res://Data/Audio/Alphabet/" + chars[k-KEY_A] + ".ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $AudioStreamPlayer
	load_sounds()
	
var last_pressed_key : int = NO_KEY
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var stream : AudioStream = null
	
	var pressed_key = NO_KEY
	for k in range(KEY_A, KEY_Z+1):
		if (Input.is_key_pressed(k)):
			pressed_key = k
	
	if pressed_key == last_pressed_key:
		return
	
	if (pressed_key == NO_KEY):
		last_pressed_key = pressed_key
		return
	
	stream = streams[pressed_key]
	if (!stream):
		return
	
	if player.is_playing:
		player.stop()
	
	player.stream = stream
	player.play()
	
	last_pressed_key = pressed_key
	
