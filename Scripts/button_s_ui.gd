extends AnimatedSprite2D

var initial_scene : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.restart.connect(_on_restart)
	GlobalEventSystem.enemy_reached_spot.connect(_on_enemy_reached_spot)
	GlobalEventSystem.character_hit.connect(_on_character_hit)
	GlobalEventSystem.character_miss.connect(_on_character_miss)
	play()

var char_hit := false
var char_mis := false
var has_reached := false

func _on_character_hit(char: String):
	char_hit = true
	visible = false
	
func _on_character_miss(char: String):
	if (initial_scene):
		char_mis = true
	
func _on_restart(credits : bool):
	initial_scene = false
	visible = false

func _on_enemy_reached_spot(enemy : Node):
	if (enemy.enemy_name == "start"):
		has_reached = true
		visible = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!initial_scene):
		return
	
	if has_reached:
		if char_mis && !char_hit:
			visible = true
		char_hit = false
		char_mis = false
