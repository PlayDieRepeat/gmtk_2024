extends Control

signal back_to_start_from_options

@export var button_packed_scene: PackedScene
var button_waiting_input: Button
var key_and_mouse_action_list: Array
var gamepad_action_list: Array

func _ready() -> void:
	assert(button_packed_scene != null, "Button Packed Scene Not Set!")
	Brainiac.input_event_has_changed.connect(_on_input_event_updated)
	key_and_mouse_action_list = Brainiac.get_knm_actions_and_events() #[action, ui_event_string, is_gamepad_event]
	gamepad_action_list = Brainiac.get_gp_actions_and_events()
	_set_all_control_buttons()

func _set_all_control_buttons() -> void:
	## Loop through and stamp out as many labels and buttons as there are actions
	## for both key/mouse and gamepads; setup labels or buttons with the correct 
	## strings and any configs. The event list for each dict has this struct:
	## [translated_text: String, original_input_event: InputEvent]
	for _list in key_and_mouse_action_list:
		var _knm_label := RichTextLabel.new()
		_knm_label.text = _list[0]
		_knm_label.fit_content = true
		%ControlsKnMLabels.add_child(_knm_label)
		_knm_label.set_owner(self)
		var _knm_button: Button = button_packed_scene.instantiate()
		%ControlsKnMButtons.add_child(_knm_button)
		_knm_button.set_owner(self)
		_knm_button.initialize_button(_list)
		
	for _list in gamepad_action_list:
		var _gp_label := RichTextLabel.new()
		_gp_label.text = _list[0]
		_gp_label.fit_content = true
		%ControlsGPLabels.add_child(_gp_label)
		_gp_label.set_owner(self)
		var _gp_button: Button = button_packed_scene.instantiate()
		%ControlsGPButtons.add_child(_gp_button)
		_gp_button.set_owner(self)
		_gp_button.initialize_button(_list)

func set_request_new_mapping(p_btn: Button, p_action: StringName, p_translated: String, p_is_gamepad: bool):
	button_waiting_input = p_btn
	Brainiac.set_change_action_event(p_action, p_translated, p_is_gamepad)

func _on_input_event_updated(p_translated_event: String):
	if button_waiting_input != null:
		button_waiting_input.update_text(p_translated_event)

func _on_back_button_pressed() -> void:
	emit_signal("back_to_start_from_options")
