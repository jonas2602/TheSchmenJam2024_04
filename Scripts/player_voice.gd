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
	player       = $talking
	load_sounds()

func get_pressed_key():
	for k in range(KEY_A, KEY_Z+1):
		if (Input.is_key_pressed(k)):
			return k
	return NO_KEY

var last_pressed_key : int = NO_KEY
func process_letter(key):
	if key  == last_pressed_key:
		return
	
	if  key == NO_KEY:
		return
	
	var stream = streams[key]
	if (stream == null):
		return
	
	if player.is_playing:
		player.stop()
	
	player.stream = stream
	player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pressed_key = get_pressed_key()
	
	$bgchants.process_chants(pressed_key, delta)
	process_letter(pressed_key)
	
	last_pressed_key = pressed_key
	
