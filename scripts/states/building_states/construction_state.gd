extends BuildingState
class_name ConstructionState


# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.set_building_texture(parent_building.building_data.construction_texture)
	parent_building.show_progress_bar(true)
	parent_building.show_waiting_dots(false)
	
	parent_building.world_timer.timeout.connect(_on_tick)

# Called every frame when this state is active.
func on_process(_delta: float) -> void:
	pass


# Called every physics frame when this state is active.
func on_physics_process(_delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(_event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	parent_building.world_timer.timeout.disconnect(_on_tick)

func _on_tick() -> void:
	if parent_building.check_construction_progress() == true:
		change_state("Open")
