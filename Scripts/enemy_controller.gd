extends Node2D

class EnemyData:
	var Cursor : int
	var Name : String
	#var Texture : Texture2D
	#var Speed : float

# Variables exposed to the editor.
@export var speed : int = 200
@export var text_box_node : Node

var data : EnemyData

func _initialize_enemy(name):
	data        = EnemyData.new()
	data.Cursor = 0
	data.Name   = name
	text_box_node.initialize_text_box(data.Name)

func _set_cursor_progress(cursor):
	data.Cursor = cursor
	text_box_node.on_new_progression_state(cursor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * speed
	
	if (position.x < 0):
		queue_free()
