extends StructureState
class_name TeardownState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref.show_structure_texture(false)
	parent_ref.show_structure_flag(true)
	parent_ref.show_build_button(false)
	parent_ref.show_progress_bar(true)
	parent_ref.show_waiting_dots(false)
	parent_ref.set_structure_name()
