extends Node

@onready var player = $AudioStreamPlayer

var _poly_stream : AudioStreamPlaybackPolyphonic

# if we have reached the polyphony limit then AudioStreamPlaybackPolyphonic
#  just return INVALID_ID and ignores the request
#  This is basically the exact behaviour we want so we just let it  be

func _on_enemy_spawned(type_info : enemy_type_info):
	if  type_info.spawn_sound:
		_poly_stream.play_stream(type_info.spawn_sound)

func _on_enemy_killed(type_info : enemy_type_info, points : int):
	if type_info.death_sound:
		_poly_stream.play_stream(type_info.death_sound)

func _on_enemy_periodic(type_info :  enemy_type_info):
	if type_info.walk_sound:
		_poly_stream.play_stream(type_info.walk_sound)

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.monster_killed.connect(_on_enemy_killed)
	_poly_stream = player.get_stream_playback()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
