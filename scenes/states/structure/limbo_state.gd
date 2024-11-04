extends StructureState
class_name LimboState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref.show_structure_texture(false)
	parent_ref.show_structure_flag(false)
	parent_ref.show_progress_bar(false)
	parent_ref.show_waiting_dots(false)
	parent_ref.show_scaffolding(false)
	parent_ref.show_build_button(false)
	parent_ref.fade_structure(true)
	parent_ref.set_structure_name()

# Called when the state machine exits this state.
func on_exit() -> void:
	parent_ref.fade_structure(false)