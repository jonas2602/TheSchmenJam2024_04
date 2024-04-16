extends Node

static var score               : int   = 0
static var multiplier          : int   = 1
static var multiplier_progress : float = 0.0

@export var multiplier_step    : int   = 20
@export var multiplier_cap     : int   = 5

func _on_restart(_credits : bool):
	score = 0
	multiplier = 1
	multiplier_progress = 0

# Triggered when player kills a monster.
func _on_monster_slain(_type_info : enemy_type_info, points : int):
	if (points == 0):
		return
	
	score += points * multiplier
	GlobalEventSystem.score_increase.emit(score)
	
	# Progress score multiplier if it's below the cap:
	if multiplier < multiplier_cap:
		multiplier_progress += (float(points) / float(multiplier)) / float(multiplier_step)
		# If the progress reaches to 1, increment multiplier
		if multiplier_progress >= 1.0:
			multiplier += 1
			multiplier_progress  = 0.0
		# Emit combo progress to tell whoever interested that multiplier and/or
		# multiplier progress has been changed.
		GlobalEventSystem.combo_progress.emit(multiplier, multiplier_progress)

# Triggered when player registers an character that doesn't match with any of
# the enemies' cursor.
func _on_character_miss(_input_char : String):
	multiplier          = 1
	multiplier_progress = 0.0
	# Emit combo progress to tell whoever interested that multiplier has been
	# changed.
	GlobalEventSystem.combo_progress.emit(multiplier, multiplier_progress)

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.monster_killed.connect(_on_monster_slain)
	GlobalEventSystem.character_miss.connect(_on_character_miss)
	GlobalEventSystem.restart.connect(_on_restart)
