extends Node2D

# Variables exposed to the editor.
@export var move_speed : int = 200
@export var text_box_node : Node
@export var sprite_rect_node : Node

var cursor_pos : int
var enemy_name : String

func _initialize_enemy(type_name, inst_name, speed, sprites):
	name = type_name
	
	move_speed = speed
	sprite_rect_node.set_sprite_frames(sprites)
	sprite_rect_node.play()
	
	cursor_pos = 0
	enemy_name = inst_name
	text_box_node.initialize_text_box(inst_name)

func _set_cursor_progress(cursor):
	cursor_pos = cursor
	text_box_node.on_new_progression_state(cursor)
	
	if (cursor == enemy_name.length()):
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * move_speed
	
	if (position.x < 0):
		queue_free()
