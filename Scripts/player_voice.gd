extends Node

@onready var _voice = $Voice

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.input_detected.connect(_voice.speak)
