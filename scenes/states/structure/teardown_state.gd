extends StructureState
class_name TeardownState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.show_building_texture(false)
	parent_building.show_building_flag(true)
	parent_building.show_build_button(false)
	parent_building.show_progress_bar(true)
	parent_building.show_waiting_dots(false)
	parent_building.set_building_name()
