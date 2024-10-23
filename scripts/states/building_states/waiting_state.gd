extends BuildingState
class_name WaitingState


# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.check_neighbors()
	parent_building.set_building_texture(parent_building.building_data.construction_texture)
	parent_building.show_waiting_dots(true)
	parent_building.show_progress_bar(false)
	parent_building.show_build_button(false)
