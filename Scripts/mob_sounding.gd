extends Node


func _on_enemy_killed(type_info : enemy_type_info, points : int):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.connect(_on_enemy_killed)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
