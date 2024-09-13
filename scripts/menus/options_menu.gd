extends Control

signal back_to_start_from_options

@export var button_packed_scene: PackedScene
var actions_and_events_dict: Dictionary
var knm_buttons_arr: Array[Node]
var gp_buttons_arr: Array[Node]
var knm_labels_arr: Array[RichTextLabel]
var gp_labels_arr: Array[RichTextLabel]

func _ready() -> void:
	assert(button_packed_scene != null, "Button Packed Scene Not Set!")
	#_get_all_control_buttons()
	Brainiac.input_events_have_changed.connect(_on_event_changed)
	actions_and_events_dict = Brainiac.get_custom_actions_and_events()
	_set_all_control_buttons()

func _get_all_control_buttons() -> void:
	knm_buttons_arr = %ControlsKnMButtons.get_children()
	gp_buttons_arr = %ControlsGPButtons.get_children()

func _set_all_control_buttons() -> void:
	for action in actions_and_events_dict:
		var _knm_label := RichTextLabel.new()
		var _gp_label := RichTextLabel.new()
		_knm_label.text = action
		_gp_label.text = action
		_knm_label.fit_content = true
		_gp_label.fit_content = true
		%ControlsKnMLabels.add_child(_knm_label)
		%ControlsGPLabels.add_child(_gp_label)
		var events: Array[String] = actions_and_events_dict[action]
		var _knm_button: Button = button_packed_scene.instantiate()
		var _gp_button: Button = button_packed_scene.instantiate()
		%ControlsKnMButtons.add_child(_knm_button)
		%ControlsGPButtons.add_child(_gp_button)
		_knm_button.update_key(action, events[0])
		if events.size() > 1:
			_gp_button.update_key(action, events[1])
		else:
			_gp_button.update_key(action, "EMPTY")

func _map_keys_to_buttons() -> void:
	if knm_buttons_arr.size() == actions_and_events_dict.size():
		for action in actions_and_events_dict:
			var _list: Array[InputEvent] = actions_and_events_dict[action]
			if true:
				pass

func _on_event_changed(p_action: StringName, p_events: Array[InputEvent]):
	pass

func _on_back_button_pressed() -> void:
	emit_signal("back_to_start_from_options")
