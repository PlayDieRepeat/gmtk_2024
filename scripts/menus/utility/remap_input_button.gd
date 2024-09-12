extends Button

var action := ""

func update_key(p_action: String, p_key: String) -> void:
	action = p_action
	text = p_key
	button_pressed = false

func _on_toggled(p_toggled_on: bool) -> void:
	if p_toggled_on == true:
		#Brainiac.change_event_on_action()
		text = "..."
