extends BuildingState
class_name TeardownState


# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.show_building_texture(false)
	parent_building.show_building_flag(true)
	parent_building.show_build_button(false)
	parent_building.show_progress_bar(true)
	parent_building.show_waiting_dots(false)
	parent_building.set_building_name()

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
	pass
