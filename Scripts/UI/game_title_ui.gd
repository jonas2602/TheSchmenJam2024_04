extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventSystem.restart.connect(_on_restart)
	pass # Replace with function body.

func _on_restart(credits : bool):
	visible = credits

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
