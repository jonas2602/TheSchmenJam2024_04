extends Node2D

@onready var _animated_legs = $LegAnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_legs.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
