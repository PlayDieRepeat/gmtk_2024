extends Button

var action: StringName
var event: InputEvent

func initialize_button(p_action: StringName, p_event: Array) -> void:
	action = p_action
	update_event(p_event)

func update_event(p_event: Array) -> void:
	text = p_event[0]
	event = p_event[1]
	button_pressed = false

func _on_toggled(p_toggled_on: bool) -> void:
	if p_toggled_on == true:
		get_owner().set_request_new_mapping(self, action, event)
		text = "..."
