extends Control

@export var number_of_text_rows: int = 3

@onready var background_panel_node         = $BackgroundPanel
@onready var background_visuals_panel_node = $BackgroundPanel/BackgroundPanelSize

static var current_text_row : int = 0

var text = "Default Andy"
var progression = 0
var previous_processed_progression = 0
var text_padding_hortizontal = 10.0
var death_initialized = false
var time_since_death = 0.0
var rng = RandomNumberGenerator.new()

# intended to be a const but useful for testing at runtime.
var global_height_start : float = 180


class TextCharacter:
	var label
	var highlight_times
	var original_position
	var velocity

var text_characters = []

func on_death():
	pass

func set_text_box_offset():
	global_position.y = global_height_start + background_panel_node.size.y * current_text_row
	current_text_row  = (current_text_row + 1) % number_of_text_rows
	pass


func initialise_text_letters(text_to_display):

	var position_x = text_padding_hortizontal

	for character in text_to_display:
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
			text_character.original_position = label.get_position()
			text_characters.append(text_character)
			background_panel_node.add_child(text_character.label)

	return position_x + text_padding_hortizontal


func intitalize_background_panel(width):

	# Set the size required to cover all the letters
	background_panel_node.set_size(Vector2(width, background_panel_node.get_size().y))
	# Adjust the realtive position of the panel so it's still centered
	background_panel_node.position.x = -background_panel_node.size.x * 0.5

	# Also initialize the background
	background_visuals_panel_node.size.x = background_panel_node.scale.x * background_panel_node.size.x / background_visuals_panel_node.scale.x + 100
	background_visuals_panel_node.size.y = background_panel_node.scale.y * background_panel_node.size.y / background_visuals_panel_node.scale.y
	background_panel_node.set_self_modulate(Color(0,0,0,0))

	pass


func initialize_text_box(enemy_text):

	var background_panel_width = initialise_text_letters(enemy_text.to_upper())

	for text_character in text_characters:
		text_character.label.set_position(text_character.label.get_position())
	
	intitalize_background_panel(background_panel_width)
	set_text_box_offset()

# Call this when the text progresses
func on_new_progression_state(new_progression):
	progression = new_progression

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Detect and animate death
	if previous_processed_progression >= text_characters.size():
		if !death_initialized:
			for text_character in text_characters:
				var explosition_angle = rng.randf_range(0.0, PI)
				var explosion_velocity = 2.0
				text_character.velocity = Vector2(cos(explosition_angle), sin(explosition_angle)) * Vector2(explosion_velocity, -explosion_velocity*3.0)
				
			death_initialized = true
		
		time_since_death += delta
		
		for text_character in text_characters:
			text_character.original_position = text_character.original_position + text_character.velocity
			text_character.velocity.y += delta*14
			text_character.velocity *= 0.98
			text_character.label.set_self_modulate(lerp(Color(1.0, 1.0, 1.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), time_since_death*0.6))
		
		var background_panel = get_node("BackgroundPanel")
		var background_panel_color = lerp(Color(1.0, 1.0, 1.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), time_since_death*5.0)
		#background_panel.set_self_modulate(background_panel_color)
		background_panel.get_child(0).set_self_modulate(background_panel_color)

	
	# Detect and do Reset
	if progression == 0 && previous_processed_progression != 0:
		for index in range(previous_processed_progression):
			if index >= text_characters.size():
				break
			
			var text_character = text_characters[index]
			text_character.label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			text_character.label.add_theme_color_override("font_shadow_color", Color(0.2, 0.2, 0.2, 1.0))
			text_character.label.add_theme_constant_override("shadow_offset_y", 2)
			text_character.label.add_theme_constant_override("shadow_outline_size", 4)
			text_character.label.set_position(text_character.original_position)
			text_character.highlight_times = -1.0
	
	previous_processed_progression = progression
	
	# Animate characters
	var index = 0
	for text_character in text_characters:
		
		if progression > index:
			text_character.highlight_times = max(text_character.highlight_times + delta, 0.0 + delta)
		elif text_character.highlight_times < 0.0:
			text_character.highlight_times = min(text_character.highlight_times + delta, 0.0)
		
		var highlight_time = text_character.highlight_times
		var label = text_character.label
		
		if text_character.highlight_times < 0.0:
			# Do text animation for reset
			var animation_factor = (1.0+highlight_time)*10.0
			
			var color = Color(1.0, animation_factor * animation_factor, animation_factor * animation_factor)
			label.add_theme_color_override("font_color", color)
			
			var label_scale = 1.0 + sin(clamp(animation_factor, 0.0, 1.0) * PI)*0.2
			label.scale.x = label_scale
			label.scale.y = label_scale
		else:
			
			if progression <= index:
				continue
				
			var animation_factor = highlight_time*6.0
			var color = lerp(Color(1.0, 1.0, 1.0), Color(0.8, 0.9, 1.0), min(animation_factor, 1.0))
			var shadow_color = lerp(Color(0.0, 0.0, 0.0), Color(1.0, 1.0, 1.0), min(animation_factor, 1.0))
			
			label.add_theme_color_override("font_color", color)
			label.add_theme_color_override("font_shadow_color", shadow_color)
			label.add_theme_constant_override("shadow_outline_size", lerp(0.0, 5.0, min(animation_factor, 1.0)))
			
			var label_scale = 1.0 + sin(clamp(animation_factor, 0.0, 1.0) * PI)
			label.scale.x = label_scale
			label.scale.y = label_scale
			
			var shake_angle = rng.randf_range(0.0, PI*2.0)
			label.set_position(text_character.original_position + Vector2(cos(shake_angle), sin(shake_angle) * 0.6))
		
		index += 1
