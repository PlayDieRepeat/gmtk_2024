extends BuildingState
class_name ConstructionState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.show_building_texture(false)
	parent_building.show_building_flag(true)
	parent_building.show_progress_bar(true)
	parent_building.show_waiting_dots(false)
	parent_building.set_building_name()
	
	parent_building.world_timer.timeout.connect(_on_tick)

# Called when the state machine exits this state.
func on_exit() -> void:
	parent_building.world_timer.timeout.disconnect(_on_tick)

func _on_tick() -> void:
	if parent_building.check_construction_progress() == true:
		change_state("Open")