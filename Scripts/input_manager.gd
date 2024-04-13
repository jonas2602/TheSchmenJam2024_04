extends Node

# Events emitted by this script:
signal input_detected(input_char)

# Handle inputs:
func _input(event):
	# Handle the regular keyboard events:
	if event is InputEventKey and event.is_pressed():
		# Get the key code as string.
		var key_code = OS.get_keycode_string(event.keycode)
		# Check if the key pressed is a single character (number or letter),
		if key_code.length() < 1 or key_code.length() > 1:
			return

		# And if the pressed character is in the alphabet range, get it to the
		# buffer. Otherwise ignore.
		var pressed_char = key_code[0]
		if  pressed_char < 'A' or pressed_char > 'Z':
			return

		# Emit the state of the input buffer.
		input_detected.emit(pressed_char)
