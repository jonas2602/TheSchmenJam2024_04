extends Control

@onready var _animated_sprite = $AnimatedSprite2D
var _back_to_idle_timer := Timer.new()

func _ready():
	GlobalEventSystem.monster_killed.connect(self._on_monster_killed)
	GlobalEventSystem.player_damaged.connect(self._on_player_damaged)
	GlobalEventSystem.input_detected.connect(self._on_input_detected)
	add_child(_back_to_idle_timer)
	_back_to_idle_timer.wait_time = 0.3
	_back_to_idle_timer.timeout.connect(self._on_back_to_idle)
	_animated_sprite.play("idle")

func _on_back_to_idle():
	_animated_sprite.play("idle")

func _on_input_detected(_input_char : String):
	if _animated_sprite.animation != "kill":
		_animated_sprite.play("summon")
		_back_to_idle_timer.start()

func _on_monster_killed(_points : int):
	if _animated_sprite.animation != "damaged":
		_animated_sprite.play("kill")
		_back_to_idle_timer.start()

func _on_player_damaged(_damage : int):
	_animated_sprite.play("damaged")
	_back_to_idle_timer.start()
