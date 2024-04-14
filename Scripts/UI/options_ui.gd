
extends Control

var pause_menu_open = false

# Open/Close on escape button press
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			toggle_pause_menu()


# Toggle whether pause menu is open or not
func toggle_pause_menu():
	pause_menu_open = !pause_menu_open
	GlobalEventSystem.enable_scrolling.emit(!pause_menu_open)
	
	get_tree().paused = pause_menu_open
	self.visible = pause_menu_open
