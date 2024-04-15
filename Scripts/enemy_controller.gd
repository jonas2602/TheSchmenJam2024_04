extends Node2D

# Variables exposed to the editor.
@export var move_speed : int = 200

@onready var sprite_rect_node = $AnimatedSprite2D
@onready var text_box_node    = $EnemyTextBoxArea

const death_raise_speed : int = 100
const death_move_speed : int = 0
const death_raise_seconds : float = 2

var cursor_pos : int
var enemy_name : String
var target_pos_x : float
enum MonsterState { Idleing, Attacking, Dying }
var current_state : MonsterState = MonsterState.Attacking
var death_raise_seconds_timer : float
var enemy_type_id : int
var vfx_kill_scene : PackedScene
var vfx_kill_scene_offset : Vector2

@export var walk_sound_period = 3.0
var walk_sound_timer : float
@onready var _audio_player = $AudioPlayer
var spawn_sound : AudioStream
var death_sound : AudioStream
var walk_sound  : AudioStream

var _type_info : enemy_type_info # heads up, at the time of writing most stuff that would be in here is kept as separate members, this is just for the enemy_killed signal

func _ready():
	GlobalEventSystem.restart.connect(_on_restart)
	
func _on_audio_player_finished():
	if (walk_sound):
		_audio_player.stream = walk_sound
		walk_sound_timer = walk_sound_period

func _initialize_enemy(type_info, type_id, target_position_x, inst_name, height_override):
	_type_info    = type_info
	var type_name = type_info.name
	name          = type_name + " (" + inst_name + ")"
	enemy_type_id = type_id
	move_speed    = type_info.speed
	
	spawn_sound = type_info.spawn_sound
	death_sound = type_info.death_sound
	walk_sound  = type_info.walk_sound

	var tex = type_info.sprites.get_frame_texture("default", 0)
	sprite_rect_node.position.y = -tex.get_height() / 2 * sprite_rect_node.scale.y
	sprite_rect_node.set_sprite_frames(type_info.sprites)
	sprite_rect_node.play()

	vfx_kill_scene        = type_info.vfx_kill
	vfx_kill_scene_offset = type_info.vfx_kill_offset
	
	cursor_pos = 0
	enemy_name = inst_name
	text_box_node.initialize_text_box(inst_name, height_override)

	target_pos_x = target_position_x

	death_raise_seconds_timer = death_raise_seconds
	
	if (spawn_sound):
		_audio_player.stop()
		_audio_player.stream = spawn_sound
		_audio_player.play()

func _on_restart():
	_set_cursor_progress(enemy_name.length())
	
func _force_death():
	_set_cursor_progress(enemy_name.length())

func _set_cursor_progress(cursor):
	cursor_pos = cursor
	text_box_node.on_new_progression_state(cursor)
	
	if ((cursor == enemy_name.length()) && (current_state != MonsterState.Dying)):
		GlobalEventSystem.monster_killed.emit(_type_info, cursor)
		current_state = MonsterState.Dying
		sprite_rect_node.stop()  # Stop the sprite animation to make pretend that the monster is dead

		var vfx = vfx_kill_scene.instantiate()
		get_tree().get_root().find_child("MainGame", true, false).add_child(vfx)
		vfx.position = position + vfx_kill_scene_offset
		
		if (_audio_player):
			_audio_player.stop()
			_audio_player.stream = death_sound
			_audio_player.play()

func process_walk_sound(delta):
	if (walk_sound == null):
		return
	
	walk_sound_timer -= delta
	if walk_sound_timer < 0.0:
		_audio_player.play()
		walk_sound_timer = walk_sound_period

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	match (current_state):
		MonsterState.Idleing:
			pass
		MonsterState.Attacking:
			# Move monster towards the player
			position.x -= delta * move_speed
			if (position.x <= target_pos_x):
				current_state = MonsterState.Idleing
				if (_type_info.stop_animation):
					sprite_rect_node.stop()
					
			process_walk_sound(delta)
		
		MonsterState.Dying:
			# Reduce of the size of the monster
			position.x -= delta * death_move_speed
			position.y -= delta * death_raise_speed
			death_raise_seconds_timer -= delta

			var weight : float = (death_raise_seconds - death_raise_seconds_timer) / death_raise_seconds
			sprite_rect_node.modulate.a = lerp(1, 0, weight)

			# Enemy should be cleaned up now
			if (death_raise_seconds_timer <= 0):
				GlobalEventSystem.monster_destroyed.emit(self)
				queue_free()


func _on_area_2d_area_entered(area):
	var other = area.get_parent()
	# print("hit: " + other.name)
	
	# Handle "collision" with player
	if (other.name == "PlayerPrefab"):
		GlobalEventSystem.player_damaged.emit(1)
		queue_free()
