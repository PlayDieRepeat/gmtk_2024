extends StateMachineState
class_name StructureState

# Reference to the character node.
@export var parent_building: Building

func _init(p_parent_ref: Building = null) -> void:
	if p_parent_ref != null and p_parent_ref.is_class("Structure"):
		parent_building = p_parent_ref

func _on_tick() -> void:
	pass
