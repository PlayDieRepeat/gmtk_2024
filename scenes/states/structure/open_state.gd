extends StructureState
class_name OpenState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.show_building_texture(true)
	parent_building.show_building_flag(false)
	parent_building.show_build_button(false)
	parent_building.show_progress_bar(false)
	parent_building.show_waiting_dots(false)
	parent_building.set_building_name()
	parent_building.set_building_name()