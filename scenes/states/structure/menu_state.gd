extends StructureState
class_name LimboState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.show_building_texture(false)
	parent_building.show_building_flag(false)
	parent_building.show_progress_bar(false)
	parent_building.show_waiting_dots(false)
	parent_building.show_scaffolding(false)
	parent_building.show_build_button(false)
	parent_building.fade_building(true)
	parent_building.set_building_name()

# Called when the state machine exits this state.
func on_exit() -> void:
	parent_building.fade_building(false)