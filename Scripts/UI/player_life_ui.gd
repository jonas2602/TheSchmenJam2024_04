extends Node2D

@onready var _full_life_container = $FullLife
@onready var _empty_life_container = $EmptyLife

var _full_life = 0
var _current_life = 0;

func _ready():
	GlobalEventSystem.player_damaged.connect(_on_player_damaged)
	_full_life = _full_life_container.get_child_count()
	_current_life = _full_life

func _on_player_damaged(damage : int):
	_current_life = _current_life - damage
	_update_ui()
	pass

func _update_ui():
	for i in range(0, _current_life):
		_full_life_container.get_child(i).visible = true
		_empty_life_container.get_child(i).visible = false

	for i in range(_current_life, _full_life):
		_full_life_container.get_child(i).visible = false
		_empty_life_container.get_child(i).visible = true
