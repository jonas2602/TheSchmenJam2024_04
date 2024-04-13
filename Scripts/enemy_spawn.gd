extends Node2D

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	var mob = mob_scene.instantiate()
	mob.position = position
	get_node("/root/").add_child(mob)
	pass # Replace with function body.
