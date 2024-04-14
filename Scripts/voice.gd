extends Node

var _streams = {}
var _last_char = ""
@export var _audio_player : AudioStreamPlayer
@export var _resource_folder : String

func load_sounds():
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for k in chars:
		var path = _resource_folder + k  + ".ogg"
		var stream = ResourceLoader.load(path)
		if stream:
			_streams[k] = ResourceLoader.load(path)
		else:
			print("Failed to load: " + path)

func speak(input_char : String):
	
	input_char = input_char.capitalize()
	if input_char.length() == 0:
		return
	
	var stream = _streams.get(input_char[0])
	if (!stream):
		return
	
	if _audio_player.is_playing:
		_audio_player.stop()
	
	_audio_player.stream = stream
	_audio_player.play()
	
	_last_char = input_char

func _ready():
	load_sounds()
	pass

func _process(delta):
	pass
