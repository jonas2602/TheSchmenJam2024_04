extends Node

class_name enemy_type_info

@export var stop_animation  : bool  = true
@export var speed           : int   = 50
@export var height          : int   = 0
@export var spawn_rate      : float = 1.0
@export var sprites         : SpriteFrames
@export var vfx_kill        : PackedScene
@export var vfx_kill_offset : Vector2
@export var possible_names  : Array[String]

@export var spawn_sound : AudioStream
@export var death_sound : AudioStream
@export var walk_sound  : AudioStream
