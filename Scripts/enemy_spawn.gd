extends Node2D

@export var next_index : int = 0
@export var mob_scene : PackedScene
@export var input_manager_node_path : NodePath
@export var enemy_inst_container : Node

var enemy_names_temp : Array[String] = ["Loki", "Odin", "Thor"]

func _on_input_detected(input_char : String):
	for i in range(0, enemy_inst_container.get_child_count()):
		var current_enemy = enemy_inst_container.get_child(i)
		# Means it's dead
		if not is_instance_valid(current_enemy):
			continue

		# Means it's dead
		if current_enemy.cursor_pos >= current_enemy.enemy_name.length():
			continue

		# Move the cursor to the next character if the input matches with char
		# at enemy cursor.
		if input_char[0] == current_enemy.enemy_name.to_upper()[current_enemy.cursor_pos]:
			current_enemy.cursor_pos += 1
		# Reset cursor if input doesn't match with char at enemy cursor.
		else:
			current_enemy.cursor_pos = 0

		current_enemy._set_cursor_progress(current_enemy.cursor_pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	var input_manager_node : Node = get_node(input_manager_node_path)
	input_manager_node.input_detected.connect(_on_input_detected)

func _on_timer_timeout():
	var type_info = $EnemyTypeContainer.get_child(next_index)
	next_index = (next_index + 1) % $EnemyTypeContainer.get_child_count()
	
	
	var mob = mob_scene.instantiate()
	mob.position    = position
	mob.position.y -= type_info.height
	
	
	var name    = enemy_names_temp[randi() % enemy_names_temp.size()]
	var speed   = type_info.speed
	var sprites = type_info.sprites
	
	enemy_inst_container.add_child(mob)
	mob._initialize_enemy(name, speed, sprites)
