
extends Control

var can_pause : bool = false
var pause_menu_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.restart.connect(_on_restart)
	GlobalEventSystem.game_ends.connect(_on_game_ends)
	pass # Replace with function body.

func _on_game_ends():
	can_pause = false

func _on_restart(credits : bool):
	can_pause = (credits == false)

# Open/Close on escape button press
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE and can_pause:
			toggle_pause_menu()


# Toggle whether pause menu is open or not
func toggle_pause_menu():
	pause_menu_open = !pause_menu_open
	GlobalEventSystem.enable_scrolling.emit(!pause_menu_open)
	
	get_tree().paused = pause_menu_open
	self.visible = pause_menu_open
