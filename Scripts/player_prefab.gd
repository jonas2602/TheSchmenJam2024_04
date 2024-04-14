extends Node2D

@export var kill_wave_scene : PackedScene
@onready var _animated_legs = $LegAnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.player_damaged.connect(_on_player_damaged)
	_animated_legs.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_damaged(damage : int):
	var wave = kill_wave_scene.instantiate()
	get_parent().add_child(wave)
	wave.position = position
