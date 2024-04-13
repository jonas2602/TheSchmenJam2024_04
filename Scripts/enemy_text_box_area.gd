extends Control

var text = "Default Andy"
var progression = 0
var previous_progression = 0
var text_padding_hortizontal = 10.0

class TextCharacter:
	var label
	var highlight_times

var text_characters = []

func initialize_text_box(enemy_text):
	text = enemy_text
	var position_x = text_padding_hortizontal
	for character in text:
		var label = Label.new()
		
		label.text = character
		label.set_size(Vector2(0.0, 0.0))
		label.update_minimum_size()
		label.set_size(label.get_minimum_size())
		label.set_position(Vector2(position_x, label.position.y))
		label.set_pivot_offset(Vector2(label.get_size().x/2.0, 20.0))
		label.add_theme_color_override("font_shadow_color", Color(0.2, 0.2, 0.2, 1.0))
		label.add_theme_constant_override("shadow_offset_y", 2)
		label.add_theme_constant_override("shadow_outline_size", 4)
		
		position_x += label.size.x;
		
		if character != ' ':
			var text_character = TextCharacter.new()
			text_character.label = label
			text_character.highlight_times = 0.0
			text_characters.append(text_character)
			add_child(text_character.label)
	
	var background_panel_node = get_node("BackgroundPanel")
	background_panel_node.set_size(Vector2(position_x + text_padding_hortizontal, background_panel_node.get_size().y))
	var half_size = (position_x - text_padding_hortizontal) / 2.0;
	
	for text_character in text_characters:
		text_character.label.set_position(Vector2(text_character.label.get_position().x - half_size, text_character.label.get_position().y))
	

# Call this when the text progresses
func on_new_progression_state(new_progression):
	previous_progression = progression
	
	if new_progression == 0:
		for text_character in text_characters:
			text_character.label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
			#text_character.label.set_position(Vector2(label.get_position().x - half_size, label.get_position().y))
	
	progression = new_progression
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Animate characters
	for index in range(progression):
		if index >= text_characters.size():
			break
		
		var text_character = text_characters[index]
		
		text_character.highlight_times += delta
		var highlight_time = text_character.highlight_times
		var label = text_character.label
		
		var animationFactor = highlight_time*5.0
		
		var color = Color(1.0-animationFactor, 1.0-animationFactor * animationFactor, 1.0-animationFactor * animationFactor * animationFactor)
		label.add_theme_color_override("font_color", color)
		
		var scale = 1.0 + sin(clamp(animationFactor, 0.0, 1.0) * PI)
		label.scale.x = scale
		label.scale.y = scale
