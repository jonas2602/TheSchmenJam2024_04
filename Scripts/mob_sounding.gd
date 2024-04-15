extends Node

@onready var _player := $MobSoundPlayer

var _poly_stream : AudioStreamPlaybackPolyphonic

# if we have reached the polyphony limit then AudioStreamPlaybackPolyphonic
#  just return INVALID_ID and ignores the request
#  This is basically the exact behaviour we want so we just let it  be

func play_sound(stream : AudioStream):
	if _player.is_playing():
		return
	if stream == null:
		return
	_player.stream = stream
	_player.play()

func _on_enemy_spawned(type_info : enemy_type_info):
	play_sound(type_info.spawn_sound)

func _on_enemy_killed(type_info : enemy_type_info, _points : int):
	play_sound(type_info.death_sound)

func _on_enemy_periodic(type_info :  enemy_type_info):
	play_sound(type_info.walk_sound)

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.monster_killed.connect(_on_enemy_killed)
	GlobalEventSystem.monster_spawned.connect(_on_enemy_spawned)
	GlobalEventSystem.monster_periodic.connect(_on_enemy_periodic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
