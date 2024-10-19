extends BuildingState
class_name WaitingState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.try_add_neighbor()
	parent_building.show_building_texture(false)
	parent_building.show_building_flag(true)
	parent_building.show_waiting_dots(true)
	parent_building.show_progress_bar(false)
	parent_building.show_build_button(false)
	parent_building.add_to_waiting_queue()
	parent_building.set_building_name()