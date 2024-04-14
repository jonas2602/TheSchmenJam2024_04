extends Control

@onready var _animated_sprite = $AnimatedSprite2D
var _back_to_idle_timer := Timer.new()

func _ready():
	GlobalEventSystem.monster_killed.connect(self._on_monster_killed)
	GlobalEventSystem.player_damaged.connect(self._on_player_damaged)
	add_child(_back_to_idle_timer)
	_back_to_idle_timer.wait_time = 0.3
	_back_to_idle_timer.timeout.connect(self._on_back_to_idle)
	_animated_sprite.play("idle")

func _on_back_to_idle():
	_animated_sprite.play("idle")

func _on_monster_killed():
	if _animated_sprite.animation != "lol":
		_animated_sprite.play("hit")
		_back_to_idle_timer.start()

func _on_player_damaged(damage : int):
	_animated_sprite.play("lol")
	_back_to_idle_timer.start()
