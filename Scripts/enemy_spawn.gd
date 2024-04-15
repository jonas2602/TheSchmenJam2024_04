extends Node2D

@export var mob_scene : PackedScene
@export var enemy_inst_container : Node

static var enemy_id_counter : int = 0

var enemy_spawn_values : Array[float]
var accumulated_spawn_rate : float = 0


func _on_input_detected(input_char : String):
	var there_was_a_hit : bool = false 
	var char_miss       : bool = true

	for i in range(enemy_inst_container.get_child_count()):
		var current_enemy = enemy_inst_container.get_child(i)
		# Means it's dead
		if not is_instance_valid(current_enemy):
			continue
		# Means it's dead
		if current_enemy.cursor_pos >= current_enemy.enemy_name.length():
			continue
		
		# If the cursor is at 1 and player registers same char with first char
		# of the name, don't reset.
		var first_two_chars_equal : bool = current_enemy.enemy_name.length() < 2 or current_enemy.enemy_name.to_upper()[0] == current_enemy.enemy_name.to_upper()[1]
		if current_enemy.cursor_pos == 1 and input_char[0] == current_enemy.enemy_name.to_upper()[0] and !first_two_chars_equal:
			char_miss       = char_miss and false;
			there_was_a_hit = true
			continue
		# Move the cursor to the next character if the input matches with char
		# at enemy cursor.
		elif input_char[0] == current_enemy.enemy_name.to_upper()[current_enemy.cursor_pos]:
			char_miss                 = char_miss and false;
			there_was_a_hit           = true
			current_enemy.cursor_pos += 1
		# Reset cursor if input doesn't match with char at enemy cursor.
		else:
			char_miss = char_miss and true;
			current_enemy.cursor_pos = 0

		current_enemy._set_cursor_progress(current_enemy.cursor_pos)
	
	if there_was_a_hit:
		GlobalEventSystem.character_hit.emit(input_char)
	if char_miss:
		GlobalEventSystem.character_miss.emit(input_char)


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.input_detected.connect(_on_input_detected)
	GlobalEventSystem.player_died.connect(_on_player_died)
	GlobalEventSystem.restart.connect(_on_restart)
	GlobalEventSystem.game_ends.connect(_on_game_ends)

	# Generate the spawn rate for the enemies
	accumulated_spawn_rate = 0

	var enemy_type_count = $EnemyTypeContainer.get_child_count()
	enemy_spawn_values.resize(enemy_type_count)

	for i in range(enemy_type_count):
		var enemy_type = $EnemyTypeContainer.get_child(i)

		accumulated_spawn_rate += enemy_type.spawn_rate
		enemy_spawn_values[i]   = accumulated_spawn_rate

	await get_tree().create_timer(1).timeout
	_spawn_enemy(2, 600, "start", 250)
	_spawn_enemy(0, 700, "credits", 300)
	_spawn_enemy(1, 800, "quit", 350)

func _on_restart(credits : bool):
	if (credits):
		_spawn_enemy(1, 400, "Albin", 0.0)
		_spawn_enemy(2, 450, "Baran", 0.0)
		_spawn_enemy(4, 500, "Denise", 0.0)
		_spawn_enemy(3, 550, "Guillaume", 0.0)
		_spawn_enemy(0, 600, "Inshal", 0.0)
		_spawn_enemy(1, 650, "Jonas", 0.0)
		_spawn_enemy(0, 700, "Louis", 0.0)
		_spawn_enemy(3, 750, "Tobias", 0.0)
		
		_spawn_enemy(4, 900, "restart", 250)
	else:
		$Timer.start()
	
func _on_player_died():
	$Timer.stop()
	
func _on_game_ends():
	_spawn_enemy(2, 600, "restart", 250)
	_spawn_enemy(0, 700, "credits", 300)
	_spawn_enemy(1, 800, "quit", 350)
	
func _on_timer_timeout():
	var random_selector : float = randf() * accumulated_spawn_rate
	var next_index : int = 0

	for i in range($EnemyTypeContainer.get_child_count()):
		if (random_selector < enemy_spawn_values[i]):
			next_index = i
			break

	var type_id                    = next_index
	var type_info                  = $EnemyTypeContainer.get_child(next_index)
	
	var inst_name = type_info.possible_names[randi() % type_info.possible_names.size()]
	var player_node = get_tree().get_root().find_child("PlayerPrefab", true, false)
	_spawn_enemy(type_id, player_node.position.x, inst_name, 0.0);
	$Timer.set_wait_time($Timer.get_wait_time() * 0.99)

func _spawn_enemy(type_index, target_position_x, inst_name, override_height):
	var type_info = $EnemyTypeContainer.get_child(type_index)
	
	var mob         = mob_scene.instantiate()
	mob.position    = position
	mob.position.y -= type_info.height
	
	enemy_id_counter += 1
	enemy_inst_container.add_child(mob)
	mob._initialize_enemy(type_info, type_index, target_position_x, inst_name, override_height)

	# Insert the fast enemies in a lower node than the slow ones.
	# Also insert any new spawned enemy on a higher possible node so the earlier
	# spawned enemies appear in front of the later ones.	
	var insertion_index = enemy_inst_container.get_children().size()-1
	for i in range(0, enemy_inst_container.get_children().size()-1):
		if enemy_inst_container.get_children()[i].enemy_type_id < type_index:
			insertion_index =enemy_inst_container.get_children().size()-1- i

	enemy_inst_container.move_child(mob, insertion_index)
	
