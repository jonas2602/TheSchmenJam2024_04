extends Node2D

@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * speed
	
	if (position.x < 0):
		queue_free()
	pass
