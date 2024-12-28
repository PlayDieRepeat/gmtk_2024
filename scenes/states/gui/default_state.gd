class_name DefaultState
extends GUIState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref._enable_glass_wall(false)

# Called when the state machine exits this state.
func on_exit() -> void:
	pass
