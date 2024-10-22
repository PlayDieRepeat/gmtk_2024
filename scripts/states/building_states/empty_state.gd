extends BuildingState
class_name EmptyState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.show_building_texture(false)
	parent_building.show_building_flag(false)
	parent_building.show_progress_bar(false)
	parent_building.show_waiting_dots(false)
	parent_building.show_scaffolding(false)
	parent_building.show_build_button(true)
	parent_building.building_data = null
	parent_building.set_building_name()
