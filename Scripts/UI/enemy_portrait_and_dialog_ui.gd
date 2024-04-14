extends Control

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _speech_text = $SpeechTextBoxRoot
var _back_to_idle_timer := Timer.new()
var _monster_speech_timer := Timer.new()
var _monster_speech_hide_timer := Timer.new()
var _speak_in_progress = false

func _ready():
	GlobalEventSystem.monster_killed.connect(self._on_monster_killed)
	GlobalEventSystem.player_damaged.connect(self._on_player_damaged)
	
	add_child(_monster_speech_timer)
	_monster_speech_timer.wait_time = 1
	_monster_speech_timer.timeout.connect(self._on_new_speech)
	_monster_speech_timer.start()
	_speech_text.visible = false

	add_child(_monster_speech_hide_timer)
	_monster_speech_hide_timer.wait_time = 3
	_monster_speech_hide_timer.timeout.connect(self._on_speech_done)
	
	add_child(_back_to_idle_timer)
	_back_to_idle_timer.wait_time = 0.3
	_back_to_idle_timer.timeout.connect(self._on_back_to_idle)
	_animated_sprite.play("idle")

func _on_new_speech():
	_back_to_idle_timer.stop()
	_monster_speech_timer.stop()
	_animated_sprite.play("talk")
	_speech_text.visible = true
	_speech_text.set_text("^Lovely^ evening #mortal# :3")
	_speak_in_progress = true
	_monster_speech_hide_timer.start()

func _on_speech_done():
	_monster_speech_hide_timer.stop()
	_speech_text.visible = false
	_speak_in_progress = false
	_on_back_to_idle()
	_monster_speech_timer.wait_time = (randi() % 11 + 5) # between 5 and 10 seconds
	_monster_speech_timer.start()

func _on_back_to_idle():
	_animated_sprite.play("idle")

func _on_monster_killed():
	if _speak_in_progress:
		return

	if _animated_sprite.animation != "lol":
		_animated_sprite.play("hit")
		_back_to_idle_timer.start()

func _on_player_damaged(damage : int):
	if _speak_in_progress:
		return

	_animated_sprite.play("lol")
	_back_to_idle_timer.start()
