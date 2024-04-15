extends Node

@onready var _voice = $Voice
@onready var _talking_player = $talking
@onready var dmg_player = $dmg_player
@export var  dmg_sounds = []

var dmg_idx = 0

func _on_dmg_player_finished():
	_voice.silence(false)

func _on_player_damaged(_damage : int):
	if dmg_sounds.size() == 0:
		return
		
	_voice.silence(true)
	dmg_player.stream = dmg_sounds[dmg_idx]
	dmg_player.play()
	dmg_player.finished.connect(_on_dmg_player_finished)
	dmg_idx += 1
	dmg_idx %= dmg_sounds.size()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.input_detected.connect(_voice.speak)
	GlobalEventSystem.player_damaged.connect(_on_player_damaged)
