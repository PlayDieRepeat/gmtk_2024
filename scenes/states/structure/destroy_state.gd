extends StructureState
class_name DestroyState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.show_building_texture(false)
	parent_building.set_building_name()