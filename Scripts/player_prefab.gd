extends Node2D

@export var kill_wave_scene : PackedScene
@onready var _animated_legs = $LegAnimatedSprite
@onready var _animated_top = $TopAnimatedSprite
var _back_to_idle_timer := Timer.new()

func _ready():
	GlobalEventSystem.player_damaged.connect(_on_player_damaged)
	GlobalEventSystem.input_detected.connect(_on_input_detected)
	add_child(_back_to_idle_timer)
	_back_to_idle_timer.wait_time = 0.3
	_back_to_idle_timer.timeout.connect(self._on_back_to_idle)
	_back_to_idle_timer.start()
	_animated_legs.play("walk")
	_animated_top.play("idle")

func _on_back_to_idle():
	_animated_top.play("idle")

func _on_player_damaged(damage : int):
	var wave = kill_wave_scene.instantiate()
	get_parent().add_child(wave)
	wave.position = position

func _on_input_detected(input_char : String):
	_animated_top.play("summon")
	_back_to_idle_timer.start()
