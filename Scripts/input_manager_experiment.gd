extends Node

@export var input_manager_node_path : NodePath

# Struct that represents an enemy's input state.
class EnemyData:
	var Name   : String
	var Cursor : int
	var Dead   : bool

# All the enemy datas in the current level:
var enemies : Array[EnemyData] = [] 

func construct_enemy(name):
	var new_enemy : EnemyData = EnemyData.new()
	new_enemy.Name   = name
	new_enemy.Cursor = 0
	new_enemy.Dead   = false 
	return new_enemy

func _test_input_detected(input_char : String):
	for i in range(0, enemies.size()):
		var current_enemy : EnemyData = enemies[i]
		
		# If the enemy is already dead, skip.
		if current_enemy.Dead == true:
			continue

		# Move the cursor to the next character if the input matches with char
		# at enemy cursor.
		if input_char[0] == current_enemy.Name[current_enemy.Cursor]:
			current_enemy.Cursor += 1
		# Reset cursor if input doesn't match with char at enemy cursor.
		else:
			current_enemy.Cursor = 0

		if current_enemy.Cursor >= current_enemy.Name.length():
			current_enemy.Dead = true
	
	print("ENEMY STATES")
	for i in range(0, enemies.size()):
		var current_enemy : EnemyData = enemies[i]
		print("--")
		print(current_enemy.Name)
		print(current_enemy.Cursor)
		print(current_enemy.Dead)
		print("--")
	print("-------")

# Called when the node enters the scene tree for the first time.
func _ready():
	var input_manager_node : Node = get_node(input_manager_node_path)
	input_manager_node.input_detected.connect(_test_input_detected)
	
	# Test enemies:
	enemies.append(construct_enemy("BARAN"))
	enemies.append(construct_enemy("BAR"))
	enemies.append(construct_enemy("RAN"))
	enemies.append(construct_enemy("ALBIN"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
