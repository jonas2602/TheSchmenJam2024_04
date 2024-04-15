extends Node2D

@export var kill_wave_scene : PackedScene
@export var revive_delay    : float

@onready var _animated_legs = $LegAnimatedSprite
@onready var _animated_top  = $TopAnimatedSprite
@onready var _animated_full = $FullAnimatedSprite

var _back_to_idle_timer := Timer.new()

enum HeroState { Idle, Walking, Hurt, Summoning, Dying, Dead, Recovering }
var current_state : HeroState = HeroState.Idle

func _ready():
	GlobalEventSystem.game_ends.connect(_on_game_ends)
	GlobalEventSystem.restart.connect(_on_restart)
	GlobalEventSystem.player_damaged.connect(_on_player_damaged)
	GlobalEventSystem.player_died.connect(_on_player_died)
	GlobalEventSystem.input_detected.connect(_on_input_detected)
	
	add_child(_back_to_idle_timer)
	_back_to_idle_timer.wait_time = 0.3
	_back_to_idle_timer.timeout.connect(self._on_back_to_idle)

	current_state = HeroState.Idle
	_animated_legs.play("idle")
	_animated_top.play("idle")

	_animated_top.animation_finished.connect(_on_top_animation_finished)
	pass


func _on_game_ends():
	current_state = HeroState.Recovering
	_animated_full.play_backwards("death")
	pass


func _on_restart(credits : bool):
	current_state = HeroState.Walking
	
	_animated_legs.play("idle" if credits else "walk")
	_animated_top.play("idle")
	pass


func _on_back_to_idle():
	current_state = HeroState.Idle
	_back_to_idle_timer.stop()
	_animated_top.play("idle")
	pass


func _send_kill_wave(max_distance : int) -> Node:
	var wave = kill_wave_scene.instantiate()
	get_parent().add_child(wave)
	wave.position     = position
	wave.max_distance = max_distance
	return wave


func _on_player_damaged(_damage : int):
	current_state = HeroState.Hurt
	_animated_top.play("hit")
	_animated_legs.visible = false
	_send_kill_wave(600)
	pass


func _on_player_died():
	_send_kill_wave(4000)
	
	current_state = HeroState.Dying
	_animated_legs.visible = false
	_animated_top.visible  = false
	_animated_full.visible = true
	_animated_full.play("death")
	pass


func _on_input_detected(_input_char : String):

	if (current_state == HeroState.Hurt):
		return

	current_state = HeroState.Summoning
	_animated_top.stop()
	_animated_top.play("summon")
	_back_to_idle_timer.start()
	pass


func _on_full_animated_sprite_animation_looped():
	match (current_state):
		HeroState.Dying:
			current_state = HeroState.Dead
			_animated_full.pause()
			_animated_full.set_frame_and_progress(2, 0)
			
			await get_tree().create_timer(revive_delay).timeout
			GlobalEventSystem.game_ends.emit()
			
		HeroState.Recovering:
			_animated_legs.visible = true
			_animated_top.visible  = true
			_animated_full.visible = false
			
			_animated_legs.play("idle")
			_animated_top.play("idle")
			_animated_full.stop()


func _on_top_animation_finished():
	if (current_state != HeroState.Hurt):
		return  # ignore all others states as those are set using timers

	_animated_legs.visible = true
	_on_back_to_idle()

	pass
