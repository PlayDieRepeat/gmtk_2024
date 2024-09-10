extends Node
## This scene will handle all of the input related config and event listening
enum InputType {AUTO_DETECT, FORCE_CONTROLLER, FORCE_MOUSE_KEYBOARD}
@export_group("Input Options")
@export var input_detect_type: InputType
@export_group("Debug Menu")
@export var debug_menu_packed: PackedScene
enum InputState {MENU_STATE, GAME_STATE, TRANSITIONAL_STATE, PAUSE_STATE, RECONNECT_STATE}
var input_state: InputState = InputState.MENU_STATE
var last_input_state: InputState = input_state
var last_input_func: Callable
var mouse_position: Vector2 = Vector2.ZERO
var mouse_relative_change: Vector2 = Vector2.ZERO
var gamepad_detected := false
var should_consume_event:= true
var is_pausing := false
var debug_menu: Node
var all_input_actions: Array[StringName]
var custom_input_actions: Array[StringName]
var custom_input_action_events := {}

signal back_to_start_from_pause_menu
signal game_state_has_changed(p_state: String)
signal input_event_has_changed

var gamepads: Array[int]= []
var gamepad_info: Array[Dictionary]= []

func _ready() -> void:
	assert(debug_menu_packed != null, "Debug menu not set!!")
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	set_process_unhandled_input(false)
	if Elephant.is_debug_build == true:
		debug_menu = debug_menu_packed.instantiate()
		add_child(debug_menu)
	all_input_actions = InputMap.get_actions()
	# All built-in actions start with "ui_", so we save them as default,
	# and save the differing ones as our custom actions, these can be modified,
	# deleted, or appended to.
	for action in all_input_actions:
		if !action.begins_with("ui_"):
			custom_input_actions.append(action)
	for action in custom_input_actions:
		for event in InputMap.action_get_events(action):
			custom_input_action_events.get(action, InputEvent)

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	_get_gamepads()

func _get_gamepads() -> bool:
	gamepads= Input.get_connected_joypads()
	if !gamepads.is_empty():
		gamepad_detected = true
		for pad in gamepads:
			gamepad_info.append(Input.get_joy_info(pad))
		return gamepad_detected
	else:
		gamepad_detected = false
		return gamepad_detected

func _input(event: InputEvent) -> void:
	#print(event.as_text())
	_process_input(event)

func _process_input(event: InputEvent) -> void:
	if should_consume_event == true:
		pass
		#get_tree().get_root().set_input_as_handled()
	
	# check the event type for mouse motion
	var str_event = event.get_class()
	match str_event:
		"InputEventMouseMotion":
			mouse_relative_change = event.relative
			mouse_position = event.global_position
			#get_tree().get_root().set_input_as_handled()
		"InputEventKey":
			Elephant.log_event(OS.get_keycode_string(event.keycode), true)
	
	if Input.is_action_just_pressed("Menu"):
		if input_state == InputState.GAME_STATE:
			#is_pausing = true TODO: probably need to remove these
			pause_game()
		elif input_state == InputState.PAUSE_STATE:
			#is_pausing = false TODO: probably need to remove these
			unpause_game()
	if Input.is_action_just_pressed("DebugMenu"):
		if Elephant.is_debug_build == true:
			debug_menu.display_or_hide_debug_ui()
	
	match input_detect_type:
		InputType.AUTO_DETECT:
			if gamepad_detected:
				_process_gamepad_input(event)
			else:
				_process_key_and_mouse_input(event)
		InputType.FORCE_CONTROLLER:
			if gamepad_detected:
				_process_gamepad_input(event)
			else:
				_prompt_for_reconnect()
		InputType.FORCE_MOUSE_KEYBOARD:
			_process_key_and_mouse_input(event)

func _process_gamepad_input(event: InputEvent) -> void:
	pass

func _process_key_and_mouse_input(event: InputEvent) -> void:
	pass

# not sure Brainiac needs this.
func _process(_delta: float) -> void:
	match input_state:
		InputState.MENU_STATE:
			pass
		InputState.GAME_STATE:
			pass
		InputState.TRANSITIONAL_STATE:
			pass
		InputState.PAUSE_STATE:
			pass
		InputState.RECONNECT_STATE:
			if gamepad_detected:
				_device_reconnected()

func _unhandled_input(event: InputEvent) -> void:
	pass

func set_menu_state() -> void:
	if input_state != InputState.MENU_STATE:
		last_input_state = input_state
		_set_last_callable(last_input_state)
		game_state_has_changed.emit("Menu State")
		input_state = InputState.MENU_STATE

func set_game_state() -> void:
	if input_state != InputState.GAME_STATE:
		last_input_state = input_state
		_set_last_callable(last_input_state)
		game_state_has_changed.emit("Game State")
		input_state = InputState.GAME_STATE

func set_transitional_state() -> void:
	if input_state != InputState.TRANSITIONAL_STATE:
		last_input_state = input_state
		_set_last_callable(last_input_state)
		input_state = InputState.TRANSITIONAL_STATE
		game_state_has_changed.emit("Load State")

func set_pause_state() -> void:
	if input_state != InputState.PAUSE_STATE:
		last_input_state = input_state
		_set_last_callable(last_input_state)
		input_state = InputState.PAUSE_STATE
		#get_tree().paused = !get_tree().paused
		game_state_has_changed.emit("Pause State")

func set_reconnect_state() -> void:
	if input_state != InputState.RECONNECT_STATE:
		last_input_state = input_state
		_set_last_callable(last_input_state)
		input_state = InputState.RECONNECT_STATE
		#get_tree().paused = !get_tree().paused
		game_state_has_changed.emit("Reconnect State")

func set_last_state() -> void:
	input_state = last_input_state
	last_input_func.call()

func get_game_state_string() -> String:
	match input_state:
		InputState.MENU_STATE:
			return "Menu"
		InputState.GAME_STATE:
			return "Game"
		InputState.TRANSITIONAL_STATE:
			return "Transitional"
		InputState.PAUSE_STATE:
			return "Pause"
		InputState.RECONNECT_STATE:
			return "Reconnect"
	return ""

func _prompt_for_reconnect() -> void:
	#Scenester.switch_scene(packed_reconnect_scene, false, false)
	Scenester.pause_for_controller_reconnection()
	set_reconnect_state()
	# TODO: create reconnect scene, add to tree, and pause, waiting for a reconnect event

func _device_reconnected() -> void:
	print("Reconnected!!")

func pause_game() -> void:
	Scenester.pause_scene()
	#var pause_menu: Node = Scenester.get_current_scene() TODO: must remove

func unpause_game() -> void:
	Scenester.unpause_scene()

func _set_last_callable(p_input_state: InputState) -> void:
	match p_input_state:
		InputState.MENU_STATE:
			last_input_func = set_menu_state
		InputState.GAME_STATE:
			last_input_func = set_game_state
		InputState.TRANSITIONAL_STATE:
			last_input_func = set_transitional_state
		InputState.PAUSE_STATE:
			last_input_func = set_pause_state
		InputState.RECONNECT_STATE:
			last_input_func = set_reconnect_state

func change_event_on_action(p_action: StringName, p_event: InputEvent) -> bool:
	InputMap.action_erase_event(p_action, p_event)
	set_process_unhandled_input(true)
	InputMap.action_add_event(p_action, p_event)
	return true

func _set_input_action_mapping_to_default() -> void:
	InputMap.load_from_project_settings()
