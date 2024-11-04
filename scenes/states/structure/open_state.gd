extends StructureState
class_name OpenState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref.show_structure_texture(true)
	parent_ref.show_structure_flag(false)
	parent_ref.show_build_button(false)
	parent_ref.show_progress_bar(false)
	parent_ref.show_waiting_dots(false)
	parent_ref.set_structure_name()
	parent_ref.set_structure_name()