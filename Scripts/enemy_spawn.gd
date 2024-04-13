extends Node2D

@export var next_index : int = 0
@export var mob_scene: PackedScene
var enemy_container : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	enemy_container = get_node("EnemyTypeContainer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	var type_info = enemy_container.get_child(next_index)
	next_index = (next_index + 1) % enemy_container.get_child_count()
	
	var mob = mob_scene.instantiate()
	mob.position    = position
	mob.position.y += type_info.height
	
	
	# TODO: var name = generate
	var speed  = type_info.speed
	var sprite = type_info.sprite
	# TODO: mob.init(name, sprite, speed)
	
	get_node("/root/").add_child(mob)
	pass # Replace with function body.
