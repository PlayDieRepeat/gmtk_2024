extends Button

@export var action := "UP"

func _ready() -> void:
	set_process_unhandled_key_input(false)
	display_key()

func display_key() -> void:
	text = "%s" % InputMap.get_actions()[0].to_upper()

func _on_toggled(p_toggled_on: bool) -> void:
	set_process_unhandled_key_input(p_toggled_on)
	if p_toggled_on == true: 
		text = "..."
	else:
		display_key()

func _unhandled_key_input(p_event: InputEvent) -> void:
	remap_key(p_event)
	set_pressed_no_signal(false)

func remap_key(p_event: InputEvent) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, p_event)
	
	text = "%s" % p_event.as_text()
