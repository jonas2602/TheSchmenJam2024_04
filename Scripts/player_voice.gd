extends Node

const MAX_INT : int = 0xFFFFFFFF
const NO_KEY  : int = MAX_INT

var _streams = {}
var _last_pressed_key = ""
@onready var _audio_player = $talking

func load_sounds():
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for k in range(KEY_A, KEY_Z+1):
		_streams[chars[k-KEY_A]] = ResourceLoader.load("res://Data/Audio/Alphabet/" + chars[k-KEY_A] + ".ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_sounds()
	GlobalEventSystem.input_detected.connect(_on_input_detected)
	
func _on_input_detected(input_char : String):
	if input_char == _last_pressed_key:
		return
	
	var stream = _streams.get(input_char[0])
	if (!stream):
		return
	
	if _audio_player.is_playing:
		_audio_player.stop()
	
	_audio_player.stream = stream
	_audio_player.play()
	
	_last_pressed_key = input_char
	
