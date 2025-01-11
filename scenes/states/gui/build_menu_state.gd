class_name BuildMenuState
extends GUIState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref._enable_glass_wall(true)

# Called when the state machine exits this state.
func on_exit() -> void:
	parent_ref._enable_glass_wall(false)