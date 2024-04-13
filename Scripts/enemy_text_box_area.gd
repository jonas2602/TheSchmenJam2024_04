extends Control

var text = "Default Andy"
var previous_progression = 0
var character_labels = []
var character_highlight_times = []
var text_padding_hortizontal = 10.0

func initialize(enemy_text):
	text = enemy_text
	pass

# Call this when the text progresses
func on_new_progression_state(new_progression):
	
	previous_progression = new_progression
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	var position_x = text_padding_hortizontal
	for character in text:
		var label = Label.new()
		
		label.text = character
		label.set_size(Vector2(0.0, 0.0))
		label.update_minimum_size()
		label.set_size(label.get_minimum_size())
		label.set_position(Vector2(position_x, label.position.y))
		label.set_pivot_offset(Vector2(label.get_size().x/2.0, 20.0))
		
		position_x += label.size.x;
		
		if character != ' ':
			character_highlight_times.append(0.0)
			character_labels.append(label)
			add_child(label)
	
	var background_panel_node = get_node("BackgroundPanel")
	background_panel_node.set_size(Vector2(position_x + text_padding_hortizontal, background_panel_node.get_size().y))
	var half_size = (position_x - text_padding_hortizontal) / 2.0;
	
	for label in character_labels:
		label.set_position(Vector2(label.get_position().x - half_size, label.get_position().y))
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Animate characters
	for index in range(previous_progression):
		if index >= character_labels.size():
			break
		
		character_highlight_times[index] += delta
		var highlight_time = character_highlight_times[index]
		var label = character_labels[index]
		
		var animationFactor = highlight_time*5.0
		
		var color = Color(1.0-animationFactor, 1.0-animationFactor * animationFactor, 1.0-animationFactor * animationFactor * animationFactor)
		label.add_theme_color_override("font_color", color)
		
		var scale = 1.0 + sin(clamp(animationFactor, 0.0, 1.0) * PI)
		label.scale.x = scale
		label.scale.y = scale
		
	
