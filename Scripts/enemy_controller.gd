extends Node2D

# Variables exposed to the editor.
@export var move_speed : int = 200

@onready var sprite_rect_node = $AnimatedSprite2D
@onready var text_box_node = $EnemyTextBoxArea

const death_raise_speed : int = 100
const death_move_speed : int = 0
const death_raise_seconds : float = 2

var cursor_pos : int
var enemy_name : String
var player_node : Node
enum MonsterState { Attacking, Dying }
var current_state : MonsterState
var death_raise_seconds_timer : float
var enemy_type_id : int
var vfx_kill_scene : PackedScene

func _initialize_enemy(type_name, inst_name, speed, sprites, type_id, text_offset, vfx_kill):
	name          = type_name + " (" + inst_name + ")"
	enemy_type_id = type_id
	move_speed    = speed

	var tex = sprites.get_frame_texture("default", 0)
	sprite_rect_node.position.y = -tex.get_height() / 2 * sprite_rect_node.scale.y
	sprite_rect_node.set_sprite_frames(sprites)
	sprite_rect_node.play()

	vfx_kill_scene = vfx_kill

	cursor_pos = 0
	enemy_name = inst_name
	text_box_node.initialize_text_box(inst_name, text_offset)

	player_node = get_tree().get_root().find_child("PlayerPrefab", true, false)

	death_raise_seconds_timer = death_raise_seconds
	
func _force_death():
	_set_cursor_progress(enemy_name.length())

func _set_cursor_progress(cursor):
	cursor_pos = cursor
	text_box_node.on_new_progression_state(cursor)
	
	if (cursor == enemy_name.length()):
		GlobalEventSystem.monster_killed.emit()
		current_state = MonsterState.Dying
		sprite_rect_node.stop()  # Stop the sprite animation to make pretend that the monster is dead

		var vfx = vfx_kill_scene.instantiate()
		get_tree().get_root().find_child("MainGame", true, false).add_child(vfx)
		vfx.position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	match (current_state):
		MonsterState.Attacking:
			# Move monster towards the player
			position.x -= delta * move_speed

			# Handle "collision" with player
			if (position.x <= player_node.position.x):
				GlobalEventSystem.player_damaged.emit(1)
				queue_free()

		MonsterState.Dying:
			# Reduce of the size of the monster
			position.x -= delta * death_move_speed
			position.y -= delta * death_raise_speed
			death_raise_seconds_timer -= delta

			var weight : float = (death_raise_seconds - death_raise_seconds_timer) / death_raise_seconds
			sprite_rect_node.modulate.a = lerp(1, 0, weight)

			# Enemy should be cleaned up now
			if (death_raise_seconds <= 0):
				GlobalEventSystem.monster_destroyed.emit()
				queue_free()
