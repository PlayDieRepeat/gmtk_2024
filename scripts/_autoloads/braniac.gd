extends Node
## This scene will handle all of the input related config and event listening
enum InputType {AUTO_DETECT, FORCE_CONTROLLER, FORCE_MOUSE_KEYBOARD}
@export_group("Input Options")
@export var input_detect_type: InputType
@export var input_states: Array[PackedScene]
@export var state_machine: FiniteStateMachine
var mouse_position: Vector2 = Vector2.ZERO
var mouse_relative_change: Vector2 = Vector2.ZERO
var joypad_left_stick: Vector2 = Vector2.ZERO
var joypad_right_stick: Vector2 = Vector2.ZERO
var gamepad_detected := false
var should_consume_event:= true
var is_pausing := false
var waiting_on_keypress_to_remap := false
var is_gamepad_event := false
var debug_menu: Node
var input_actions: Array[StringName]
var input_action_knm_events := {}
var input_action_gp_events := {}
var remap_waiting_info = []
var controller_deadzone := 0.2

signal game_state_has_changed(p_state: String)
signal input_event_has_changed(p_event_context: Array)

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
		var translated_event_arr: Array
		var _events: Array[InputEvent] = InputMap.action_get_events(action)
		for _event in _events:
			translated_event_arr = _translate_input_event(_event)
			if translated_event_arr.is_empty():
				printerr("Input translation FAILED!!")
			else:
				if translated_event_arr[1] == true:
					input_action_knm_events[action] = translated_event_arr
				else:
					input_action_gp_events[action] = translated_event_arr

## Translator algo takes an InputEvent and returns a player-facing string to
## represent the InputEvent
func _translate_input_event(p_input_event: InputEvent) -> Array:
	var event_as_text := p_input_event.as_text()
	var translated_string: String
	match p_input_event.get_class():
		"InputEventMouseButton":
			is_gamepad_event = false
			if event_as_text.contains("Left Mouse Button"):
				translated_string = "Left Mouse Click"
			elif event_as_text.contains("Right Mouse Button"):
				translated_string = "Right Mouse Click"
			elif event_as_text.contains("Mouse Wheel Up"):
				translated_string = "Mouse Wheel Up"
			elif event_as_text.contains("Mouse Wheel Down"):
				translated_string = "Mouse Wheel Down"
				
			return [translated_string, is_gamepad_event, p_input_event]
		"InputEventKey":
			is_gamepad_event = false
			if event_as_text.contains(" (Physical)"):
				return [p_input_event.as_text().replacen(" (Physical)", ""), is_gamepad_event, p_input_event]
			else:
				return [p_input_event.as_text(), is_gamepad_event, p_input_event]
		"InputEventJoypadMotion":
			is_gamepad_event = true
			if event_as_text.contains("Left Stick Y-Axis"):
				if p_input_event.get_axis_value() < 0:
					translated_string = "Left Stick Up"
				elif p_input_event.get_axis_value() > 0:
					translated_string = "Left Stick Down"
				else:
					pass
			elif event_as_text.contains("Left Stick X-Axis"):
				if p_input_event.get_axis_value() < 0:
					translated_string = "Left Stick Left"
				elif p_input_event.get_axis_value() > 0:
					translated_string = "Left Stick Right"
				else:
					pass
			elif event_as_text.contains("Right Stick Y-Axis"):
				if p_input_event.get_axis_value() < 0:
					translated_string = "Right Stick Up"
				elif p_input_event.get_axis_value() > 0:
					translated_string = "Right Stick Down"
				else:
					pass
			elif event_as_text.contains("Right Stick X-Axis"):
				if p_input_event.get_axis_value() < 0:
					translated_string = "Right Stick Left"
				elif p_input_event.get_axis_value() > 0:
					translated_string = "Right Stick Right"
				else:
					pass
			elif event_as_text.contains("Left Trigger"):
				translated_string = "Left Trigger"
			elif event_as_text.contains("Right Trigger"):
				translated_string = "Right Trigger"
				
			return [translated_string, is_gamepad_event, p_input_event]
		"InputEventJoypadButton":
			is_gamepad_event = true
			if event_as_text.contains("Left Action"):
				translated_string = "Face Button Left"
			elif event_as_text.contains("Right Action"):
				translated_string = "Face Button Right"
			elif event_as_text.contains("Top Action"):
				translated_string = "Face Button Top"
			elif event_as_text.contains("Bottom Action"):
				translated_string = "Face Button Bottom"
			elif event_as_text.contains("Joypad Button 4"):
				translated_string = "Select"
			elif event_as_text.contains("Joypad Button 6"):
				translated_string = "Start"
			elif event_as_text.contains("Joypad Button 7"):
				translated_string = "Left Stick Click"
			elif event_as_text.contains("Joypad Button 8"):
				translated_string = "Right Stick Click"
			elif event_as_text.contains("Joypad Button 9"):
				translated_string = "Left Shoulder"
			elif event_as_text.contains("Joypad Button 10"):
				translated_string = "Right Shoulder"
			elif event_as_text.contains("Joypad Button 11"):
				translated_string = "D-Pad Up"
			elif event_as_text.contains("Joypad Button 12"):
				translated_string = "D-Pad Down"
			elif event_as_text.contains("Joypad Button 13"):
				translated_string = "D-Pad Left"
			elif event_as_text.contains("Joypad Button 14"):
				translated_string = "D-Pad Right"
				
			return [translated_string, is_gamepad_event, p_input_event]
		_:
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
		if remap_waiting_info[2] == true: # is a gamepad
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
		for _action in input_actions:
			if event.is_action(_action):
				if input_detect_type == InputType.AUTO_DETECT:
					_process_action(event, _action)
				elif is_controller(event) and (input_detect_type == InputType.FORCE_CONTROLLER):
					_process_gamepad_action(event, _action)
				elif !is_controller(event) and (input_detect_type == InputType.FORCE_MOUSE_KEYBOARD):
					_process_key_and_mouse_action(event, _action)
		
		match str_event:
			"InputEventMouseMotion":
				_process_mouse_motion(event)
				#get_tree().get_root().set_input_as_handled()
			"InputEventJoypadMotion":
				_process_joypad_motion(event)
			_:
				if Input.is_action_just_pressed("menu"):
					if state_machine.current_state.name == "Game":
						#is_pausing = true TODO: probably need to remove these
						pause_game()
					elif state_machine.current_state.name == "Pause":
						#is_pausing = false TODO: probably need to remove these
						unpause_game()

func is_controller(p_event: InputEvent) -> bool:
	if p_event.is_class("InputEventJoypadMotion") or p_event.is_class("InputEventJoypadButton"):
		return true
	
	return false

func _process_action(p_event: InputEvent, p_action: StringName) -> void:
	emit_signal(p_action)

func _process_mouse_motion(p_event: InputEvent) -> void:
	mouse_relative_change = p_event.relative
	mouse_position = p_event.global_position

#JOY_AXIS_TRIGGER_LEFT = 4
#Game controller left trigger axis.
#JOY_AXIS_TRIGGER_RIGHT = 5
#Game controller right trigger axis.
# TODO: implement triggers here?? do we care?
func _process_joypad_motion(p_event: InputEvent) -> void:
	if abs(p_event.get_axis_value()) >= controller_deadzone:
		match p_event.axis:
			JOY_AXIS_LEFT_X:
				joypad_left_stick.x = p_event.axis_value
			JOY_AXIS_LEFT_Y:
				joypad_left_stick.y = p_event.axis_value
			JOY_AXIS_RIGHT_X:
				joypad_right_stick.x = p_event.axis_value
			JOY_AXIS_RIGHT_Y:
				joypad_right_stick.y = p_event.axis_value

func _process_gamepad_action(p_event: InputEvent, p_action: StringName) -> void:
	emit_signal(p_action)

func _process_key_and_mouse_action(p_event: InputEvent, p_action: StringName) -> void:
	emit_signal(p_action)

### takes the unhandled input event and adds it to the InputMap
### needs to know what action to add it to
### TODO: change where action comes from, away from remap_waiting_info
### then the action event dictionaries are updated with the new mapping
### then the caught input is translated into a generic, ui and user_facing
### string that gets signal broadcasted (and caught by the options menu)
### then its logged, and finally a bool is flipped so we dont keep remapping new inputs randomly
### and the process for unhandled input is set to false ... I wonder if we need that?
### TODO: look into the need for set_process_unhandled_input's use
func _update_event_and_notify(p_event: InputEvent) -> void:
	if InputMap.action_has_event(remap_waiting_info[0], remap_waiting_info[3]): # input same as saved info
		input_event_has_changed.emit(remap_waiting_info[1]) # send same info back
	else:
		InputMap.action_erase_event(remap_waiting_info[0], remap_waiting_info[3])
		InputMap.action_add_event(remap_waiting_info[0], p_event)
		var _tranlated_event: String = _update_action_mapping(remap_waiting_info, p_event)
		# signal input_event_has_changed(p_action: StringName, p_event: InputEvent)
		input_event_has_changed.emit(_tranlated_event)
		Elephant.log_event("Action Event Updated: " + remap_waiting_info[0] + _tranlated_event)
	waiting_on_keypress_to_remap = false
	set_process_unhandled_input(false)
	#get_tree().get_root().set_input_as_handled()
	
	#remap_waiting_info = [p_action, p_translated_text, p_is_gamepad, _event]

func _update_action_mapping(p_remap_context: Array, p_event: InputEvent) -> String:
	var _translation_arr: Array = _translate_input_event(p_event)
	if _translation_arr[1] == true: #gamepad
		if input_action_gp_events.erase(p_remap_context[0]):
			input_action_gp_events[p_remap_context[0]] = _translation_arr
	else: # knm
		if input_action_knm_events.erase(p_remap_context[0]):
			input_action_knm_events[p_remap_context[0]] = _translation_arr
		
	return _translation_arr[0]

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
	

func set_change_action_event(p_action: StringName, p_translated_text: String, p_is_gamepad: bool) -> void:
	var _event: InputEvent = get_event_from_action(p_action, p_is_gamepad)
	remap_waiting_info = [p_action, p_translated_text, p_is_gamepad, _event]
	waiting_on_keypress_to_remap = true
	set_process_unhandled_input(true)

func get_event_from_action(p_action: StringName, p_is_gamepad: bool) -> InputEvent:
	var _event: InputEvent
	if p_is_gamepad:
		_event = input_action_gp_events[p_action][2]
	else:
		_event = input_action_knm_events[p_action][2]
	
	return _event

func _set_input_action_mapping_to_default() -> void:
	InputMap.load_from_project_settings()

func get_knm_actions_and_events() -> Array:
	var _arr: Array
	for _key in input_action_knm_events:
		_arr.append([_key, input_action_knm_events[_key][0], input_action_knm_events[_key][1]])
	return _arr

func get_gp_actions_and_events() -> Array:
	var _arr: Array
	for _key in input_action_gp_events:
		_arr.append([_key, input_action_gp_events[_key][0], input_action_gp_events[_key][1]])
	return _arr

func register_for_action(p_action_string: StringName, p_callable: Callable):
	for _signal in input_actions:
		if _signal == p_action_string:
			if !self.is_connected(_signal, p_callable):
				self.connect(_signal, p_callable)
