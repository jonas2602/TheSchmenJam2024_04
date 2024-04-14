extends Control

@export var current_score   : int = 0
@export var displayed_score : int = 0
@export var max_increment   : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$PointsLabel.text = str(0)
	GlobalEventSystem.monster_killed.connect(self._on_monster_killed)

func _on_monster_killed(points : int):
	current_score += points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var delta_score : int = min(current_score - displayed_score, max_increment)
	displayed_score += delta_score
	$PointsLabel.text = str(displayed_score)
	pass
