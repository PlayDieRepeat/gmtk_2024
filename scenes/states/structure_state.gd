extends StateMachineState
class_name StructureState

# Reference to the character node.
@export var parent_ref: Structure

func _init(p_parent_ref: Structure = null) -> void:
	if p_parent_ref != null and p_parent_ref.is_class("Structure"):
		parent_ref = p_parent_ref

func _on_tick() -> void:
	pass
