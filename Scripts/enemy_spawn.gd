extends Node2D

@export var next_index : int = 0
@export var mob_scene : PackedScene
@export var input_manager_node_path : NodePath

var enemies : Array[Node]
var enemy_container : Node
var enemy_names_temp : Array[String] = ["Loki", "Odin", "Thor"]

func _on_input_detected(input_char : String):
	for i in range(0, enemies.size()):
		var current_enemy = enemies[i]
		# Means it's dead
		if not is_instance_valid(current_enemy):
			continue

		var current_enemy_data = current_enemy.data
		var current_cursor     = current_enemy_data.Cursor
		# Means it's dead
		if current_cursor >= current_enemy_data.Name.length():
			continue

		# Move the cursor to the next character if the input matches with char
		# at enemy cursor.
		if input_char[0] == current_enemy_data.Name.to_upper()[current_cursor]:
			current_cursor += 1
		# Reset cursor if input doesn't match with char at enemy cursor.
		else:
			current_cursor = 0

		current_enemy._set_cursor_progress(current_cursor)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	enemy_container = get_node("EnemyTypeContainer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	var input_manager_node : Node = get_node(input_manager_node_path)
	input_manager_node.input_detected.connect(_on_input_detected)

func _on_timer_timeout():
	var type_info = enemy_container.get_child(next_index)
	next_index = (next_index + 1) % enemy_container.get_child_count()
	
	
	var mob = mob_scene.instantiate()
	mob.position    = position
	mob.position.y += type_info.height
	
	
	# TODO: var name = generate
	var speed  = type_info.speed
	var sprite = type_info.sprite
	# TODO: mob.init(name, sprite, speed)
	
	get_node("/root/").add_child(mob)
	mob._initialize_enemy(enemy_names_temp[randi() % enemy_names_temp.size()])
	
	# TODO: Erase the mob from array when they get deleted.
	enemies.append(mob)
