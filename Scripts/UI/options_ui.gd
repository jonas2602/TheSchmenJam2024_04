
extends Control

var pause_menu_open = false

# Open/Close on escape button press
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			toggle_pause_menu()
	pass


# Toggle whether pause menu is open or not
func toggle_pause_menu():
	pause_menu_open = !pause_menu_open
	
	get_tree().paused = pause_menu_open
	self.visible = pause_menu_open
	pass 


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
