extends Node2D

@export var kill_wave_scene : PackedScene
@export var revive_delay : float
@onready var _animated_legs = $LegAnimatedSprite
@onready var _animated_top = $TopAnimatedSprite
@onready var _animated_full = $FullAnimatedSprite
var _back_to_idle_timer := Timer.new()

enum HeroState { Idle, Walking, Summoning, Dying, Dead, Recovering }
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

func _on_game_ends():
	current_state = HeroState.Recovering
	$FullAnimatedSprite.play_backwards("death")
	
func _on_restart(_credits : bool):
	current_state = HeroState.Walking
	_animated_legs.play("walk")
	_animated_top.play("idle")

func _on_back_to_idle():
	current_state = HeroState.Idle
	_back_to_idle_timer.stop()
	_animated_top.play("idle")

func _send_kill_wave(max_distance : int) -> Node:
	var wave = kill_wave_scene.instantiate()
	get_parent().add_child(wave)
	wave.position     = position
	wave.max_distance = max_distance
	return wave

func _on_player_damaged(_damage : int):
	_send_kill_wave(600)

func _on_player_died():
	_send_kill_wave(4000)
	
	current_state = HeroState.Dying
	_animated_legs.visible      = false
	_animated_top.visible       = false
	$FullAnimatedSprite.visible = true
	$FullAnimatedSprite.play("death")
	
func _on_input_detected(_input_char : String):
	current_state = HeroState.Summoning
	_animated_top.stop()
	_animated_top.play("summon")
	_back_to_idle_timer.start()
	
func _on_full_animated_sprite_animation_looped():
	match (current_state):
		HeroState.Dying:
			current_state = HeroState.Dead
			$FullAnimatedSprite.pause()
			$FullAnimatedSprite.set_frame_and_progress(2, 0)
			
			await get_tree().create_timer(revive_delay).timeout
			GlobalEventSystem.game_ends.emit()
			
		HeroState.Recovering:
			_animated_legs.visible = true
			_animated_top.visible  = true
			_animated_full.visible = false
			
			_animated_legs.play("idle")
			_animated_top.play("idle")
			_animated_full.stop()
