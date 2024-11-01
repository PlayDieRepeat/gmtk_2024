extends StateMachineState
class_name InputState

# Reference to the character node.
@export var parent: Node

func _init(p_parent_ref: Node = null) -> void:
	if p_parent_ref != null and p_parent_ref.name == "Brainiac":
		parent = p_parent_ref

func _on_tick() -> void:
	pass
