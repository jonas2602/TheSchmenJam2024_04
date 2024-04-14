extends Control

var text = "Lovely evening #mortal# :3"
var characters_per_second = 0.04
var wait_per_character = 0.1
var progression = 0.0
var shown_characters = 0

class SpeechTextCharacter:
	var label
	var highlight_time
	var angry_effect
	var original_position

var text_characters = []
var text_padding_hortizontal = 10.0

func set_text(new_text):
	text = new_text
	
	var angry_effect = false
	
	var position_x = text_padding_hortizontal
	for character in text:
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
		
		if character == '#':
			angry_effect = !angry_effect
		
		var text_character = SpeechTextCharacter.new()
		text_character.label = label
		text_character.highlight_time = 0.0
		text_character.angry_effect = angry_effect
		text_character.original_position = label.position
		text_characters.append(text_character)
		add_child(label)
	
	var background_panel_node = get_node("BackgroundPanel")
	background_panel_node.set_size(Vector2(position_x + text_padding_hortizontal, background_panel_node.get_size().y))
	var half_size = (position_x - text_padding_hortizontal) / 2.0
	
	#for text_character in text_characters:
		#text_character.label.set_position(Vector2(text_character.label.get_position().x - half_size, text_character.label.get_position().y))
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text("Lovely evening mortal :3")
	pass

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
		
		var color = Color(animationFactor, animationFactor * animationFactor, animationFactor * animationFactor * animationFactor, clamp(animationFactor, 0.0, 1.0))
		label.add_theme_color_override("font_color", color)
		
		var scale = 1.0 + sin(clamp(animationFactor, 0.0, 1.0) * PI) * 0.5
		label.scale.x = scale
		label.scale.y = scale
		
	
