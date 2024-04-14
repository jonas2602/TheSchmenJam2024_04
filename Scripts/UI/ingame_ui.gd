extends Control

var enemy_text_box_scene = load("res://Scenes/enemy_text_box_area.tscn")

var rng = RandomNumberGenerator.new()

var test_spawn_padding = 50.0

var enemy_text_boxes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# test spawning of text box areas
	for index in range(10):
		break
		var position_x = rng.randf_range(0.0 + test_spawn_padding, get_size().x - test_spawn_padding)
		var position_y = rng.randf_range(0.0 + test_spawn_padding, get_size().y - test_spawn_padding)
		
		var enemy_text_box = enemy_text_box_scene.instantiate()
		enemy_text_box.set_position(Vector2(position_x, position_y))
		
		enemy_text_boxes.append(enemy_text_box)
		add_child(enemy_text_box)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
