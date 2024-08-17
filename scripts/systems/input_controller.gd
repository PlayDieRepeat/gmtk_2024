extends Node
## This scene will handle all of the input related config and event listening
enum InputType {AUTO_DETECT, FORCE_CONTROLLER, FORCE_MOUSE_KEYBOARD}
@export_group("Input Options")
@export var input_detect_type: InputType

var gamepads: Array[int]= []
var gamepad_info: Array[Dictionary]= []

func _detect_gamepads() -> bool:
	gamepads= Input.get_connected_joypads()
	
	if !gamepads.is_empty():
		print("Gamepad(s) detected!")
		for pad in gamepads:
			gamepad_info.append(Input.get_joy_info(pad))
		return true
	else:
		return false

func _process(_delta: float) -> void:
	match input_detect_type:
		InputType.AUTO_DETECT:
			print("Auto-Detecting input type")
			if _detect_gamepads():
				pass
		InputType.FORCE_CONTROLLER:
			print("Forcing controller input type")
			if _detect_gamepads():
				pass
		InputType.FORCE_MOUSE_KEYBOARD:
			print("Forcing KnM input type")
