extends Control

@export var current_score   : int = 0
@export var displayed_score : int = 0
@export var max_increment   : int = 1

var rng = RandomNumberGenerator.new()
var interpolation_time = 0.4
var interpolation_progress = 0.0
var interpolated_score = 0.0
var from_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$PointsLabel.text = str(0)
	GlobalEventSystem.score_increase.connect(self._on_score_changed)

func _on_score_changed(new_score : int):
	interpolation_progress = 0.0
	from_score = displayed_score
	current_score += new_score
	
	var gained_difference_total = current_score - from_score
	
	$GainedLabel.rotation = 0.0 + rng.randf_range(-1.0, 1.0)
	$GainedLabel.text = "+"+str(gained_difference_total)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interpolation_progress += delta
	var interpolation_factor = clamp(interpolation_progress / interpolation_time, 0.0, 1.0)
	var factor2 = 1.0-((1.0-interpolation_factor) * (1.0-interpolation_factor))
	interpolated_score = lerp(from_score, current_score, factor2)
	
	displayed_score = int(interpolated_score)
	
	
	$GainedLabel.scale.x = 1.0 + sin(interpolation_factor*PI)*0.5
	$GainedLabel.scale.y = 1.0 + sin(interpolation_factor*PI)*0.5
	$GainedLabel.set_self_modulate(lerp(Color(1.0, 1.0, 1.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), interpolation_factor * interpolation_factor))
		
	$PointsLabel.text = str(displayed_score)
	$PointsLabel.scale.x = 1.0 + sin(interpolation_factor*PI)*0.1
	$PointsLabel.scale.y = 1.0 + sin(interpolation_factor*PI)*0.1
	pass
