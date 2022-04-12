extends Node

export var debug_enabled: = true
var debug: = false

var debug_quit = "ui_cancel"
var debug_mouse_release = "mouse_input"

func _ready() -> void:
	if OS.is_debug_build(): debug = debug_enabled
	if debug: debug_init()
	
	game_init()

# Production code goes here
func game_init():
	pass


# Only runs when in the editor and debug set to true
# DO NOT put production code here
func debug_init():
	"""
	Semi-automated key detection for debug keys
	"""
	print("** Debug mode enabled **")
	
	var keys = ""
	var first = true
	for action in InputMap.get_action_list(debug_quit):
		if action is InputEventKey:
			if not first: keys += ", "
			else: first = false
			keys += "'%s'" % OS.get_scancode_string(action.get_scancode_with_modifiers()).replace("+", " + ")
	print("** %s to close **" % keys)
	
	keys = ""
	first = true
	for action in InputMap.get_action_list(debug_mouse_release):
		if action is InputEventKey:
			if not first: keys += ", "
			else: first = false
			keys += "'%s'" % OS.get_scancode_string(action.get_scancode_with_modifiers()).replace("+", " + ")
	print("** %s to toggle mouse lock **" % keys)


func _input(event: InputEvent) -> void:
	if not debug: return
	
	if event.is_action_pressed(debug_quit):
		get_tree().quit() # Quits the game TODO: Pause Menu
	
	if event.is_action_pressed(debug_mouse_release):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
