extends Node

# https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/
# Singleton autoloaded in the project settings

signal player_damaged(damage : int)
signal monster_killed(points : int)
signal monster_destroyed()
signal input_detected(input_char : String)
signal character_hit(char: String)
signal character_miss(char: String)
