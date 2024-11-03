extends StructureState
class_name WaitingState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref.try_add_neighbor()
	parent_ref.show_structure_texture(false)
	parent_ref.show_structure_flag(true)
	parent_ref.show_waiting_dots(true)
	parent_ref.show_progress_bar(false)
	parent_ref.show_build_button(false)
	parent_ref.add_to_waiting_queue()
	parent_ref.set_structure_name()
