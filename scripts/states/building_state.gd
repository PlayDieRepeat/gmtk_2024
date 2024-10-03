extends StateMachineState
class_name BuildingState

# Reference to the character node.
@export var parent_building: Building

func _init(p_parent_ref: Building = null) -> void:
	if p_parent_ref != null and p_parent_ref.is_class("Building"):
		parent_building = p_parent_ref

func _on_tick() -> void:
	pass
