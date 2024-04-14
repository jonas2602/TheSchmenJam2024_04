extends Node2D

func _ready():
	GlobalEventSystem.enable_scrolling.connect(self._enable_scrolling)

func _enable_scrolling(enable : bool):
	for i in range(get_child_count()):
		var mat = get_child(i).get_material()
		if mat:
			mat.set_shader_parameter("moving", enable)
