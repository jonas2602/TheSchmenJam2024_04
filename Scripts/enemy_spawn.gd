extends Node2D

@export var next_index : int = 0
@export var mob_scene : PackedScene
@export var enemy_inst_container : Node

static var enemy_id_counter : int = 0

func _on_input_detected(input_char : String):
	var there_was_a_hit : bool = false 
	var char_miss       : bool = true

	for i in range(0, enemy_inst_container.get_child_count()):
		var current_enemy = enemy_inst_container.get_child(i)
		# Means it's dead
		if not is_instance_valid(current_enemy):
			continue
		# Means it's dead
		if current_enemy.cursor_pos >= current_enemy.enemy_name.length():
			continue
		
		# If the cursor is at 1 and player registers same char with first char
		# of the name, don't reset.
		if current_enemy.cursor_pos == 1 and input_char[0] == current_enemy.enemy_name.to_upper()[0]:
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
	$Timer.start()
	GlobalEventSystem.input_detected.connect(_on_input_detected)
	GlobalEventSystem.player_died.connect(_on_player_died)
	GlobalEventSystem.restart.connect(_on_restart)


func _on_restart():
	$Timer.start()
	
func _on_player_died():
	$Timer.stop()
	
func _on_timer_timeout():
	var type_id                    = next_index
	var type_info                  = $EnemyTypeContainer.get_child(next_index)
	next_index                     = (next_index + 1) % $EnemyTypeContainer.get_child_count()
	
	$Timer.set_wait_time($Timer.get_wait_time() * 0.99)
	
	var mob         = mob_scene.instantiate()
	mob.position    = position
	mob.position.y -= type_info.height
	
	enemy_id_counter += 1
	
	enemy_inst_container.add_child(mob)
	mob._initialize_enemy(type_info, type_id)

	# Insert the fast enemies in a lower node than the slow ones.
	# Also insert any new spawned enemy on a higher possible node so the earlier
	# spawned enemies appear in front of the later ones.	
	var insertion_index = enemy_inst_container.get_children().size()-1
	for i in range(0, enemy_inst_container.get_children().size()-1):
		if enemy_inst_container.get_children()[i].enemy_type_id < type_id:
			insertion_index =enemy_inst_container.get_children().size()-1- i

	enemy_inst_container.move_child(mob, insertion_index)
