extends InputState
class_name MenuState

# Called when the state machine enters this state.
func on_enter() -> void:
	#parent.call_method_here(parent.parameter.resourceID.value)
	print("I'm in the Menu State Yo!!")
	pass

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
