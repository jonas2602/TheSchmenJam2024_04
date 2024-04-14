extends Control

var text = "^Lovely^ evening #mortal# :3"
const characters_per_second = 0.04
var progression = 0.0
var shown_characters = 0
var box_original_position
var is_left_aligned = false

var rng = RandomNumberGenerator.new()

@onready var voice = $Voice

class SpeechTextCharacter:
	var label
	var highlight_time
	var angry_effect
	var love_effect
	var original_position

var text_characters = []
var text_padding_hortizontal = 10.0

func set_text(new_text):
	progression = 0.0
	shown_characters = 0
	
	# Clear character
	for text_character in text_characters:
		remove_child(text_character.label)
	
	text_characters.clear()
	
	# Setup characters
	text = new_text
	
	var angry_effect = false
	var love_effect = false
	
	var position_x = text_padding_hortizontal
	for character in text:
		
		# Parse effect markers
		if character == '#':
			angry_effect = !angry_effect
			continue
			
		if character == '^':
			love_effect = !love_effect
			continue
		
		var label = Label.new()
		
		label.text = character
		label.set_size(Vector2(0.0, 0.0))
		label.update_minimum_size()
		label.set_size(label.get_minimum_size())
		label.set_position(Vector2(position_x, label.position.y))
		label.set_pivot_offset(Vector2(label.get_size().x/2.0, 20.0))
		label.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 0.0))
		label.add_theme_color_override("font_shadow_color", Color(0.3, 0.3, 0.3, 1.0))
		label.add_theme_constant_override("shadow_offset_y", 2)
		label.add_theme_constant_override("shadow_outline_size", 5)

		position_x += label.size.x;
		

		
		var text_character = SpeechTextCharacter.new()
		text_character.label = label
		text_character.highlight_time = 0.0
		text_character.angry_effect = angry_effect
		text_character.love_effect = love_effect
		text_character.original_position = label.position
		text_characters.append(text_character)
		add_child(label)
	
	var background_panel_node = get_node("BackgroundPanel")
	var box_width = position_x + text_padding_hortizontal
	
	if !is_left_aligned:
		background_panel_node.set_position(box_original_position - Vector2(box_width, 0))
		for text_character in text_characters:
			text_character.original_position -= Vector2(box_width, 0.0);
			text_character.label.set_position(text_character.original_position)
			
		
	background_panel_node.set_size(Vector2(box_width, background_panel_node.get_size().y))
	var half_size = (position_x - text_padding_hortizontal) / 2.0
	

	


func _ready():
	var background_panel_node = get_node("BackgroundPanel")
	box_original_position = background_panel_node.get_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progression += delta
	
	while progression > characters_per_second:
		shown_characters += 1
		progression -= characters_per_second
	
	# Animate characters
	for index in range(shown_characters):
		if index >= text_characters.size():
			break
		
		var text_character = text_characters[index]
		
		text_character.highlight_time += delta
		var highlight_time = text_character.highlight_time
		var label = text_character.label
		
		var animationFactor = highlight_time*5.0
		
		var scale = 1.0 + sin(clamp(animationFactor, 0.0, 1.0) * PI) * 0.5
		label.scale.x = scale
		label.scale.y = scale
		
		var base_color = Color(animationFactor, animationFactor * animationFactor, animationFactor * animationFactor * animationFactor, clamp(animationFactor, 0.0, 1.0))
		var color = base_color
		
		# Do angry shaking
		if text_character.angry_effect:
			var shake_angle = rng.randf_range(0.0, PI*2.0)
			label.set_position(text_character.original_position + Vector2(cos(shake_angle), sin(shake_angle)))
			var anger_factor = 10*(text_characters[0].highlight_time+100.0)
			var angry_color = Color(1.0, 0.75 + 0.25 * sin(anger_factor), 0.75 + 0.25 * sin(anger_factor))
			color = lerp(base_color, angry_color, min(highlight_time, 1.0))
		
		# Do love effect
		if text_character.love_effect:
			#var shake_angle = rng.randf_range(0.0, PI)
			label.set_position(text_character.original_position + Vector2(0.0, 2.0 + sin((text_characters[0].highlight_time + text_character.original_position.x * 0.1) * 10)))
			var love_factor = 2*(highlight_time+100.0)
			var love_color = Color(1.0, 0.65 + 0.15 * sin(love_factor), 0.85 + 0.15 * sin(love_factor))
			color = lerp(base_color, love_color, min(highlight_time, 1.0))
			
		label.add_theme_color_override("font_color", color)
	
