extends Node

@export var speed           : int   = 50
@export var height          : int   = 0
@export var spawn_rate      : float = 1.0
@export var sprites         : SpriteFrames
@export var vfx_kill        : PackedScene
@export var vfx_kill_offset : Vector2
@export var possible_names  : Array[String]
