extends StructureState
class_name ConstructionState

# Called when the state machine enters this state.
func on_enter() -> void:
	parent_ref.show_structure_texture(false)
	parent_ref.show_structure_flag(true)
	parent_ref.show_progress_bar(true)
	parent_ref.show_waiting_dots(false)
	parent_ref.set_structure_name()
	
	parent_ref.world_timer.timeout.connect(_on_tick)

# Called when the state machine exits this state.
func on_exit() -> void:
	parent_ref.world_timer.timeout.disconnect(_on_tick)

func _on_tick() -> void:
	if parent_ref.check_construction_progress() == true:
		change_state("Open")