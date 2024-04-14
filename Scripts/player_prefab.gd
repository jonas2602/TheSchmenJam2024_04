extends Node2D

@export var kill_wave_scene : PackedScene
@export var game_over_scene : PackedScene
@onready var _animated_legs = $LegAnimatedSprite
@onready var _animated_top = $TopAnimatedSprite
var _back_to_idle_timer := Timer.new()

enum HeroState { Idle, Walking, Summoning, Dying, Dead }
var current_state : HeroState = HeroState.Idle

func _ready():
	GlobalEventSystem.restart.connect(_on_restart)
	GlobalEventSystem.player_damaged.connect(_on_player_damaged)
	GlobalEventSystem.player_died.connect(_on_player_died)
	GlobalEventSystem.input_detected.connect(_on_input_detected)
	add_child(_back_to_idle_timer)
	_back_to_idle_timer.wait_time = 0.3
	_back_to_idle_timer.timeout.connect(self._on_back_to_idle)
	_back_to_idle_timer.start()
	_animated_legs.play("walk")
	_animated_top.play("idle")

func _on_restart():
	_animated_legs.visible      = true
	_animated_top.visible       = true
	$FullAnimatedSprite.visible = false
	
	_animated_legs.play("walk")
	_animated_top.play("idle")	

func _on_back_to_idle():
	_animated_top.play("idle")

func _send_kill_wave(max_distance : int):
	var wave = kill_wave_scene.instantiate()
	get_parent().add_child(wave)
	wave.position     = position
	wave.max_distance = max_distance

func _on_player_damaged(_damage : int):
	_send_kill_wave(600)

func _on_player_died():
	_send_kill_wave(4000)
	
	_animated_legs.visible      = false
	_animated_top.visible       = false
	$FullAnimatedSprite.visible = true
	$FullAnimatedSprite.play("death")
	
func _on_input_detected(_input_char : String):
	_animated_top.play("summon")
	_back_to_idle_timer.start()
	

func _on_full_animated_sprite_animation_looped():
	$FullAnimatedSprite.pause()
	$FullAnimatedSprite.set_frame_and_progress(2, 0)
	
	var game_over = game_over_scene.instantiate()
	get_tree().get_root().add_child(game_over)
