extends Node

# https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/
# Singleton autoloaded in the project settings

signal enable_scrolling(enable : bool)
signal player_damaged(damage : int)
signal player_died()
signal game_ends()
signal restart(credits : bool)
signal monster_spawned(type_info  : enemy_type_info)
signal monster_killed(type_info   : enemy_type_info, points : int)
signal monster_periodic(type_info : enemy_type_info)
signal monster_destroyed()
signal kill_wave_complete()
signal input_detected(input_char : String)
signal character_hit(char: String)
signal character_miss(char: String)

# Score system api:
signal score_increase(new_score : int)
signal combo_progress(multiplier: int, multiplier_progress : float)
