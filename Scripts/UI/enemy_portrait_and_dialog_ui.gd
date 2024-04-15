extends Control

@export var possible_text : Array[String]

@onready var animated_sprite   = $AnimatedSprite2D
@onready var speech_text       = $SpeechTextBoxRoot

var back_to_idle_timer        := Timer.new()
var monster_speech_timer      := Timer.new()
var monster_speech_hide_timer := Timer.new()
var speak_in_progress          = true         # start as true so the summoner doesn't talk during start menu


func _ready():
	GlobalEventSystem.monster_killed.connect(self._on_monster_killed)
	GlobalEventSystem.player_damaged.connect(self._on_player_damaged)
	GlobalEventSystem.player_died.connect(self._on_player_dead)
	GlobalEventSystem.restart.connect(self._on_game_restart)
	
	add_child(monster_speech_timer)
	monster_speech_timer.wait_time = 1
	monster_speech_timer.timeout.connect(self._on_new_speech)
	speech_text.visible = false

	add_child(monster_speech_hide_timer)
	monster_speech_hide_timer.wait_time = 3
	monster_speech_hide_timer.timeout.connect(self._on_speech_done)
	
	add_child(back_to_idle_timer)
	back_to_idle_timer.wait_time = 0.3
	back_to_idle_timer.timeout.connect(self._on_back_to_idle)

	animated_sprite.play("idle")
	pass

func _on_new_speech():
	back_to_idle_timer.stop()
	monster_speech_timer.stop()
	animated_sprite.play("talk")
	speech_text.visible = true
	speech_text.set_text(possible_text[randi() % possible_text.size()])
	speak_in_progress = true
	monster_speech_hide_timer.start()

func _on_speech_done(stop_timer : bool = false):
	monster_speech_hide_timer.stop()
	speech_text.visible = false
	speak_in_progress = false
	_on_back_to_idle()
	monster_speech_timer.wait_time = (randi() % 1 + 5) # between 1 and 5 seconds

	if (stop_timer):
		monster_speech_timer.stop()
	else:
		monster_speech_timer.start()

func _on_back_to_idle():
	animated_sprite.play("idle")

func _on_monster_killed(_type_info : enemy_type_info, _points : int):
	if speak_in_progress:
		return

	if animated_sprite.animation != "lol":
		animated_sprite.play("hit")
		back_to_idle_timer.start()


func _on_player_damaged(_damage : int):
	if speak_in_progress:
		return

	animated_sprite.play("lol")
	back_to_idle_timer.start()


func _on_player_dead():
	_on_speech_done(true)
	speak_in_progress = true
	animated_sprite.play("laugh")
	pass


func _on_game_restart(credits : bool):

	if (credits):
		return

	speak_in_progress = false
	animated_sprite.play("idle")
	monster_speech_timer.start()
	pass
