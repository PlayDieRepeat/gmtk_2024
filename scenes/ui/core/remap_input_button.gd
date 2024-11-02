extends Button

var action: StringName
var event: InputEvent
var is_gamepad_event: bool

func initialize_button(p_info: Array) -> void:
	action = p_info[0]
	update_text(p_info[1])
	is_gamepad_event = p_info[2]

func update_text(p_text: String) -> void:
	text = p_text
	button_pressed = false

func _on_toggled(p_toggled_on: bool) -> void:
	if p_toggled_on == true:
		get_owner().set_request_new_mapping(self, action, text, is_gamepad_event)
		text = "..."
