extends BuildingState
class_name TeardownState


# Called when the state machine enters this state.
func on_enter() -> void:
	parent_building.building_texture.texture = parent_building.building_data.teardown_texture
	parent_building.progress_bar.visible = true
	parent_building.waiting_dots.visible = false
	parent_building.waiting_dots.stop()

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
