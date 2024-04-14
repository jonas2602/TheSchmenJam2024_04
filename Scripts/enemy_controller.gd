extends Node2D

# Variables exposed to the editor.
@export var move_speed : int = 200

@onready var sprite_rect_node = $AnimatedSprite2D
@onready var text_box_node = $EnemyTextBoxArea

var cursor_pos : int
var enemy_name : String
var player_node : Node

func _initialize_enemy(type_name, inst_name, speed, sprites):
	name = type_name + " (" + inst_name + ")"
	
	move_speed = speed
	var tex = sprites.get_frame_texture("default", 0)
	sprite_rect_node.position.y = -tex.get_height() / 2 * sprite_rect_node.scale.y
	sprite_rect_node.set_sprite_frames(sprites)
	sprite_rect_node.play()

	cursor_pos = 0
	enemy_name = inst_name
	text_box_node.initialize_text_box(inst_name)

	player_node = get_tree().get_root().find_child("PlayerPrefab", true, false)

func _set_cursor_progress(cursor):
	cursor_pos = cursor
	text_box_node.on_new_progression_state(cursor)
	
	if (cursor == enemy_name.length()):
		GlobalEventSystem.monster_killed.emit()
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * move_speed
	
	if (position.x <= player_node.position.x):
		GlobalEventSystem.player_damaged.emit(1)
		queue_free()
