extends Control

@export var start_scene : PackedScene
@onready var _start_button = $Start
@onready var _credits_button = $Start
@onready var _exit_button = $Start

func _ready():
	_start_button.pressed.connect(self._start_button_pressed)
	_credits_button.pressed.connect(self._start_button_pressed)
	_exit_button.pressed.connect(self._start_button_pressed)

func _start_button_pressed():
	get_tree().change_scene_to_file(start_scene.resource_path)

func _credits_button_pressed():
	pass

func _exit_button_pressed():
	get_tree().quit()
