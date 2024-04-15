extends Node2D

@onready var _full_life_container = $FullLife
@onready var _empty_life_container = $EmptyLife
var _idle_timer := Timer.new()

var _full_life = 0
var _current_life = 0;

func _ready():
	GlobalEventSystem.restart.connect(_on_restart)
	GlobalEventSystem.player_damaged.connect(_on_player_damaged)
	_full_life = _full_life_container.get_child_count()
	_current_life = _full_life
	add_child(_idle_timer)
	_idle_timer.wait_time = 5
	_idle_timer.timeout.connect(self._play_animation)
	_idle_timer.start()
	_play_animation()

func _on_restart(_credits : bool):
	_current_life = _full_life
	_update_ui()	
	
func _on_player_damaged(damage : int):
	_current_life = _current_life - damage
	_current_life = max(_current_life, 0)
	_update_ui()
	if (_current_life == 0):
		GlobalEventSystem.player_died.emit()
		GlobalEventSystem.enable_scrolling.emit(false)

func _update_ui():
	for i in range(0, _current_life):
		_full_life_container.get_child(i).visible = true
		_empty_life_container.get_child(i).visible = false

	for i in range(_current_life, _full_life):
		_full_life_container.get_child(i).visible = false
		_empty_life_container.get_child(i).visible = true

func _play_animation():
	for i in range(0, _full_life):
		_full_life_container.get_child(i).play("idle")
