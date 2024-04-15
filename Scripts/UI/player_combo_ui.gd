extends Node2D

@onready var active_combo_container   = $ActiveCombo
@onready var deactive_combo_container = $DeactiveCombo
var _idle_timer := Timer.new()

var multiplier_cap      : int   = 0
var multiplier          : int   = 0
var multiplier_progress : float = 0.0
var combo_time = 0.0

func _ready():
	GlobalEventSystem.restart.connect(_on_restart)
	GlobalEventSystem.combo_progress.connect(_on_combo_progress)

	multiplier_cap = active_combo_container.get_child_count()
	multiplier     = 1
	
	add_child(_idle_timer)
	
	_idle_timer.wait_time = 5
	_idle_timer.timeout.connect(self._play_animation)
	_idle_timer.start()
	
	_play_animation()
	_update_ui()

func _on_combo_progress(new_multiplier : int, new_multiplier_progress : float):
	multiplier          = new_multiplier
	multiplier_progress = new_multiplier_progress
	_update_ui()

func _on_restart():
	multiplier          = 1
	multiplier_progress = 0.0
	_update_ui()

func _process(delta):
	combo_time += delta
	_update_ui()

func _update_ui():
	$ComboText.text = "x%.1f" % float(multiplier)
	$ComboText.scale.x = 0.8+multiplier_progress
	$ComboText.scale.y = 0.8+multiplier_progress
	$ComboText.pivot_offset = Vector2(0.0, 20.0*sin(combo_time * 3))
	#Label.new().offset_bottom
	
	for i in range(0, multiplier):
		active_combo_container.get_child(i).visible   = true
		deactive_combo_container.get_child(i).visible = false

	for i in range(multiplier, multiplier_cap):
		active_combo_container.get_child(i).visible            = false
		deactive_combo_container.get_child(i).visible          = true
		deactive_combo_container.get_child(i).scale = Vector2(0.25, 0.25)
		
	if multiplier < multiplier_cap:
		deactive_combo_container.get_child(multiplier).scale = lerp(Vector2(0.25, 0.25), Vector2(0.8, 0.8), multiplier_progress)

func _play_animation():
	for i in range(0, multiplier_cap):
		active_combo_container.get_child(i).play("idle")
