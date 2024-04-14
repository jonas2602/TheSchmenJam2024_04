extends AudioStreamPlayer

@export var chant_remain_time : float = 0.556
@export var volume_min  : float = -60.0 #volume is in db
@export var volume_max  : float = -6.0
@export var volume_step : float = 2.0
var chant_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = load("res://Data/Audio/weird_chants.ogg")
	volume_db = volume_min
	GlobalEventSystem.character_hit.connect(_on_character_hit)
	GlobalEventSystem.character_miss.connect(_on_character_miss)

func start_chant():
	play()
	chant_timer = chant_remain_time

func stop_chant():
	stop()
	volume_db = volume_min
	chant_timer = -1

var char_hit_this_frame = false;
var char_missed_this_frame = false;

func _on_character_hit(_input_char : String):
	char_hit_this_frame = true

func _on_character_miss(_input_char : String):
	char_missed_this_frame = true

func is_chanting():
	return playing

func process_char_hit():
	if not is_chanting():
		return start_chant()
	volume_db += volume_step
	chant_timer = chant_remain_time

func process_char_miss():
	if is_chanting():
		stop_chant()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if char_hit_this_frame:
		process_char_hit()
	elif char_missed_this_frame:
		process_char_miss()
	else:
		chant_timer -= delta
	
	if  is_chanting() && chant_timer <  0:
		stop_chant()
	
	volume_db = clampf(volume_db, volume_min, volume_max)
	char_hit_this_frame = false;
	char_missed_this_frame = false;
