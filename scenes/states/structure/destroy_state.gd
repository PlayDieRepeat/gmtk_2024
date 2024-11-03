extends StructureState
class_name DestroyState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref.show_structure_texture(false)
	parent_ref.set_structure_name()