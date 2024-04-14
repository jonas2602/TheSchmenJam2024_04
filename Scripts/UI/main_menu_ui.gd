extends Control

@export var start_scene : PackedScene

@onready var _main_menu_node = $MainMenu
@onready var _start_button = $MainMenu/Start
@onready var _credits_button = $MainMenu/Credits
@onready var _exit_button = $MainMenu/Exit

@onready var _credits_node = $Credits
@onready var _credits_back_button  = $Credits/Back

func _ready():
	_start_button.pressed.connect(self._start_button_pressed)
	_credits_button.pressed.connect(self._credits_button_pressed)
	_exit_button.pressed.connect(self._exit_button_pressed)
	_credits_back_button.pressed.connect(self._credits_back_button_pressed)

func _start_button_pressed():
	get_tree().change_scene_to_file(start_scene.resource_path)

func _credits_button_pressed():
	_credits_node.visible = true
	_main_menu_node.visible = false
	
func _credits_back_button_pressed():
	_credits_node.visible = false
	_main_menu_node.visible = true

func _exit_button_pressed():
	get_tree().quit()

