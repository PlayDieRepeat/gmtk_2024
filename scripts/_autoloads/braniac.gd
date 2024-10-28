extends Node
## This scene will handle all of the input related config and event listening
enum InputType {AUTO_DETECT, FORCE_CONTROLLER, FORCE_MOUSE_KEYBOARD}
@export_group("Input Options")
@export var input_detect_type: InputType
@export var input_states: Array[PackedScene]
@export var state_machine: FiniteStateMachine
var mouse_position: Vector2 = Vector2.ZERO
var mouse_relative_change: Vector2 = Vector2.ZERO
var gamepad_detected := false
var should_consume_event:= true
var is_pausing := false
var waiting_on_keypress_to_remap := false
var debug_menu: Node
var input_actions: Array[StringName]
var input_action_knm_events := {}
var input_action_gp_events := {}
var remap_info = []
var controller_deadzone := 0.2

signal game_state_has_changed(p_state: String)
signal input_event_has_changed(p_action: StringName, p_event: Array)

var gamepads: Array[int]= []
var gamepad_info: Array[Dictionary]= []

func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_generate_states()
	state_machine.change_state("Menu")
	_get_all_actions_from_map()
	_create_signals_from_actions()
	_write_action_event_dicts(input_actions)
	Elephant.log_event("All Input Actions and Events captured.")

func _generate_states() -> void:
	for state in input_states:
		var state_instance = state.instantiate()
		state_instance.parent = self
		state_machine.add_child(state_instance)	

func _get_all_actions_from_map() -> void:
	var all_input_actions: Array[StringName]
	all_input_actions = InputMap.get_actions()
	assert(!all_input_actions.is_empty(), "ERROR: Could not get Input Actions!")
	# All built-in actions start with "ui_", so we get all actions and save the 
	# differing ones as our custom actions, these can be modified, deleted, 
	# or appended to.
	for action in all_input_actions:
		if !action.begins_with("ui_"):
			input_actions.append(action)

func _create_signals_from_actions() -> void:
	for action in input_actions:
		add_user_signal(action)

## Save all actions and events as two dictionaries, one for GP and one for KnM
##  with key=Action(StringName) and values as a list of [String, InputEvent] 
## where the string is a translated version of the InputEvent.as_text() output
func _write_action_event_dicts(p_actions_arr: Array[StringName]) -> void:
	for action in p_actions_arr:
		var knm_list: Array
		var gp_list: Array
		var _list: Array[InputEvent]
		_list = InputMap.action_get_events(action)
		knm_list = _translate_input_event(_list[0])
		input_action_knm_events[action] = knm_list
		if _list.size() > 1:
			gp_list = _translate_input_event(_list[1])
			input_action_gp_events[action] = gp_list
		else:
			input_action_gp_events[action] = ["EMPTY", null]

## Translator algo takes an InputEvent and returns a player-facing string to
## represent the InputEvent
func _translate_input_event(p_input_event: InputEvent) -> Array:
	var _string: String = p_input_event.get_class()
	match p_input_event.get_class():
		"InputEventMouseButton":
			var _button_str: String = p_input_event.as_text()
			if p_input_event.as_text().contains("Left Mouse Button"):
				return ["Left Mouse Click", p_input_event]
			if p_input_event.as_text().contains("Right Mouse Button"):
				return ["Right Mouse Click", p_input_event]
			if p_input_event.as_text().contains("Mouse Wheel Up"):
				return ["Mouse Wheel Up", p_input_event]
			if p_input_event.as_text().contains("Mouse Wheel Down"):
				return ["Mouse Wheel Down", p_input_event]
		"InputEventKey":
			var _key_str: String = p_input_event.as_text()
			if p_input_event.as_text().contains(" (Physical)"):
				return [p_input_event.as_text().replacen(" (Physical)", ""), p_input_event]
			else:
				return [p_input_event.as_text(), p_input_event]
		"InputEventJoypadMotion":
			var _stick_str: String = p_input_event.as_text()
			if _stick_str.contains("Left Stick Y-Axis"):
				if p_input_event.get_axis_value() < 0:
					return ["Left Stick Up", p_input_event]
				elif p_input_event.get_axis_value() > 0:
					return ["Left Stick Down", p_input_event]
			elif _stick_str.contains("Left Stick X-Axis"):
				if p_input_event.get_axis_value() < 0:
					return ["Left Stick Left", p_input_event]
				elif p_input_event.get_axis_value() > 0:
					return ["Left Stick Right", p_input_event]
			elif _stick_str.contains("Right Stick Y-Axis"):
				if p_input_event.get_axis_value() < 0:
					return ["Right Stick Up", p_input_event]
				elif p_input_event.get_axis_value() > 0:
					return ["Right Stick Down", p_input_event]
			elif _stick_str.contains("Right Stick X-Axis"):
				if p_input_event.get_axis_value() < 0:
					return ["Right Stick Left", p_input_event]
				elif p_input_event.get_axis_value() > 0:
					return ["Right Stick Right", p_input_event]
			elif _stick_str.contains("Left Trigger"):
				return ["Left Trigger", p_input_event]
			elif _stick_str.contains("Right Trigger"):
				return ["Right Trigger", p_input_event]
		"InputEventJoypadButton":
			var _button_str: String = p_input_event.as_text()
			if p_input_event.as_text().contains("Left Action"):
				return ["Face Button Left", p_input_event]
			elif p_input_event.as_text().contains("Right Action"):
				return ["Face Button Right", p_input_event]
			elif p_input_event.as_text().contains("Top Action"):
				return ["Face Button Top", p_input_event]
			elif p_input_event.as_text().contains("Bottom Action"):
				return ["Face Button Bottom", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 4"):
				return ["Select", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 6"):
				return ["Start", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 7"):
				return ["Left Stick Click", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 8"):
				return ["Right Stick Click", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 9"):
				return ["Left Shoulder", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 10"):
				return ["Right Shoulder", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 11"):
				return ["D-Pad Up", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 12"):
				return ["D-Pad Down", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 13"):
				return ["D-Pad Left", p_input_event]
			elif p_input_event.as_text().contains("Joypad Button 14"):
				return ["D-Pad Right", p_input_event]
	return []

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

func _process(_delta: float) -> void:
	match state_machine.current_state.name:
		"Reconnect":
			if gamepad_detected:
				_device_reconnected()
		#InputState.MENU_STATE:
			#pass
		#InputState.GAME_STATE:
			#pass
		#InputState.TRANSITIONAL_STATE:
			#pass
		#InputState.PAUSE_STATE:
			#pass


func _unhandled_input(event: InputEvent) -> void:
	var str_event = event.get_class()
	if waiting_on_keypress_to_remap == true:
		if remap_info[2] == true: # is a gamepad
			match str_event:
				"InputEventJoypadMotion":
					if abs(event.get_axis_value()) >= controller_deadzone:
						_update_event_and_notify(event)
				"InputEventJoypadButton":
					_update_event_and_notify(event)
		else:
			match str_event:
				"InputEventMouseMotion":
					mouse_relative_change = event.relative
					mouse_position = event.global_position
					#get_tree().get_root().set_input_as_handled()
				"InputEventMouseButton":
					_update_event_and_notify(event)
				"InputEventKey":
					_update_event_and_notify(event)
	else:
		match str_event:
			"InputEventMouseMotion":
				_process_mouse_motion()
				mouse_relative_change = event.relative
				mouse_position = event.global_position
				#get_tree().get_root().set_input_as_handled()
			"InputEventJoypadMotion":
				pass
			_:
				for i in range(input_actions.size()):
					if event.is_action(input_actions[i]):
						emit_signal(input_actions[i])

	if Input.is_action_just_pressed("menu"):
		if state_machine.current_state.name == "Game":
			#is_pausing = true TODO: probably need to remove these
			pause_game()
		elif state_machine.current_state.name == "Pause":
			#is_pausing = false TODO: probably need to remove these
			unpause_game()
	
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

func _process_mouse_motion() -> void:
	pass

func _process_gamepad_input(event: InputEvent) -> void:
	pass

func _process_key_and_mouse_input(event: InputEvent) -> void:
	pass

func _update_event_and_notify(p_event: InputEvent) -> void:
	InputMap.action_add_event(remap_info[0], p_event)
	_write_action_event_dicts(input_actions)
	var _tranlated_event: Array
	_tranlated_event = _translate_input_event(p_event)
	# signal input_event_has_changed(p_action: StringName, p_event: InputEvent)
	input_event_has_changed.emit(remap_info[0], _tranlated_event)
	Elephant.log_event("Action Event Updated: " + remap_info[0] + _tranlated_event[0])
	waiting_on_keypress_to_remap = false
	set_process_unhandled_input(false)
	#get_tree().get_root().set_input_as_handled()

func set_menu_state() -> void:
	state_machine.change_state("Menu")
	Elephant.log_event("InputState: Menu State")
	game_state_has_changed.emit("Menu State")

func set_game_state() -> void:
	state_machine.change_state("Game")
	Elephant.log_event("InputState: Game State")
	game_state_has_changed.emit("Game State")

func set_transitional_state() -> void:
	state_machine.change_state("Transitional")
	Elephant.log_event("InputState: Load State")
	game_state_has_changed.emit("Load State")

func set_pause_state() -> void:
	state_machine.change_state("Pause")
	Elephant.log_event("InputState: Pause State")
	game_state_has_changed.emit("Pause State")

func set_reconnect_state() -> void:
	state_machine.change_state("Reconnect")
	Elephant.log_event("InputState: Reconnect State")
	game_state_has_changed.emit("Reconnect State")

func get_game_state_string() -> String:
	return state_machine.current_state.name

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

func change_event_on_action(p_action: StringName, p_event: InputEvent, p_is_gamepad: bool) -> void:
	InputMap.action_erase_event(p_action, p_event)
	remap_info = [p_action, p_event, p_is_gamepad]
	waiting_on_keypress_to_remap = true
	set_process_unhandled_input(true)

func _set_input_action_mapping_to_default() -> void:
	InputMap.load_from_project_settings()

func get_knm_actions_and_events() -> Dictionary:
	return input_action_knm_events

func get_gp_actions_and_events() -> Dictionary:
	return input_action_gp_events

func register_for_action(p_action_string: StringName, p_callable: Callable):
	for _signal in input_actions:
		if _signal == p_action_string:
			if !self.is_connected(_signal, p_callable):
				self.connect(_signal, p_callable)
