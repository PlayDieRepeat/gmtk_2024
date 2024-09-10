extends Button

@export var action := "UP"
var current_key : InputEvent

func _ready() -> void:
	set_process_unhandled_key_input(false)
	update_key()
	display_key()

func display_key() -> void:
	pass #text = current_key

func update_key() -> void:
	pass# current_key = "%s" % InputMap.get_actions()[0].to_upper()

func _on_toggled(p_toggled_on: bool) -> void:
	if p_toggled_on == true:
		#Brainiac.change_event_on_action()
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
