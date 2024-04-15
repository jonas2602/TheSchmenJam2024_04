extends Node2D

var         zoom_target : float = 1.0
@export var decay_rate  : float = 4.0
@export var zoom_ratio  : float = 90.0

var current_zoom  = 1.0
var zooming       = false
var zooming_for_monster = false
var zoom_progress = 0.0
var zoom_additional_scale = 1.0

func _ready() -> void:
	GlobalEventSystem.monster_killed.connect(apply_noise_shake)
	GlobalEventSystem.character_hit.connect(apply_noise_shake_char)
	GlobalEventSystem.combo_progress.connect(on_combo_progress)
	zoom_target = 1.0
	
func on_combo_progress(multiplier: int, multiplier_progress : float):
	zoom_additional_scale = multiplier

func apply_noise_shake_char(char : String) -> void:
	if zooming_for_monster:
		return

	zoom_target   = 1.0 + ((randi() % 3 + 1 / zoom_additional_scale) / (zoom_ratio * 2.5)) / 2.5
	zooming       = true
	zoom_progress = 0.0

func apply_noise_shake(type_info : enemy_type_info, points : int) -> void:
	if points == 0:
		return

	zoom_target         = 1.0 + ((points / (zoom_ratio * 10.0) ) + (zoom_additional_scale / 50.0)) / 2.0
	zooming             = true
	zooming_for_monster = true
	zoom_progress       = 0.0

func _process(delta: float) -> void:
	if zooming:
		zoom_progress += decay_rate * delta
		if zoom_progress >= 1.0:
			zoom_progress       = 1.0
			zooming             = false
			zooming_for_monster = false
		current_zoom = lerpf(zoom_target, 1.0, zoom_progress) 
		self.zoom.x = current_zoom
		self.zoom.y = current_zoom
