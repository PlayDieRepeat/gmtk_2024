extends Control

signal back_to_start_from_options

@export var button_packed_scene: PackedScene
var button_waiting_input: Button
var actions_and_knm_events_dict: Dictionary
var actions_and_gp_events_dict: Dictionary

func _ready() -> void:
	assert(button_packed_scene != null, "Button Packed Scene Not Set!")
	Brainiac.input_event_has_changed.connect(_on_event_changed)
	actions_and_knm_events_dict = Brainiac.get_knm_actions_and_events()
	actions_and_gp_events_dict = Brainiac.get_gp_actions_and_events()
	_set_all_control_buttons()

func _set_all_control_buttons() -> void:
	## Loop through and stamp out as many labels and buttons as there are actions
	## for both key/mouse and gamepads; setup labels or buttons with the correct 
	## strings and any configs. The event list for each dict has this struct:
	## [translated_text: String, original_input_event: InputEvent]
	for _action in actions_and_knm_events_dict:
		var _knm_label := RichTextLabel.new()
		_knm_label.text = _action
		_knm_label.fit_content = true
		%ControlsKnMLabels.add_child(_knm_label)
		_knm_label.set_owner(self)
		var _knm_button: Button = button_packed_scene.instantiate()
		%ControlsKnMButtons.add_child(_knm_button)
		_knm_button.set_owner(self)
		var _knm_event: Array = actions_and_knm_events_dict[_action]
		_knm_button.initialize_button(_action, _knm_event)
	for _action in actions_and_gp_events_dict:
		var _gp_label := RichTextLabel.new()
		_gp_label.text = _action
		_gp_label.fit_content = true
		%ControlsGPLabels.add_child(_gp_label)
		_gp_label.set_owner(self)
		var _gp_button: Button = button_packed_scene.instantiate()
		%ControlsGPButtons.add_child(_gp_button)
		_gp_button.set_owner(self)
		var _gp_event: Array = actions_and_gp_events_dict[_action]
		_gp_button.initialize_button(_action, _gp_event)

func set_request_new_mapping(p_btn: Button, p_action: StringName, p_event: InputEvent):
	button_waiting_input = p_btn
	if button_waiting_input.get_parent() == %ControlsGPButtons:
		Brainiac.change_event_on_action(p_action, p_event, true)
	else:
		Brainiac.change_event_on_action(p_action, p_event, false)
	

func _on_event_changed(p_action: StringName, p_event: Array):
	if button_waiting_input != null:
		button_waiting_input.update_event(p_event)

func _on_back_button_pressed() -> void:
	emit_signal("back_to_start_from_options")
