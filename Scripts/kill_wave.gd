extends Node2D

@export var speed : float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += delta * speed
	if (position.x > 2000):
		queue_free()
	pass

func _on_area_2d_area_entered(area):
	var enemy = area.get_parent()
	# print("hit" + enemy.name)
	enemy._force_death()
