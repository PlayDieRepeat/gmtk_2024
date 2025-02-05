extends Node3D

var capture_mouse := true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build"):
		capture_mouse = !capture_mouse
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if capture_mouse else Input.MOUSE_MODE_VISIBLE

	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
