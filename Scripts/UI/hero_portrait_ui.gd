extends Control

@onready var _animated_sprite = $AnimatedSprite2D
const ANIM_COOLDOWN_MS = 25
var stop_anim_cooldown = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_anything_pressed()):
		_animated_sprite.play("summon")
		stop_anim_cooldown = ANIM_COOLDOWN_MS
	elif (stop_anim_cooldown <= 0):
		_animated_sprite.play("idle")

	if stop_anim_cooldown > 0:
		stop_anim_cooldown = stop_anim_cooldown - 1
