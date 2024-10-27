extends StateMachineState
class_name InputState

# Reference to the character node.
@export var parent: Brainiac

func _init(p_parent_ref: Brainiac = null) -> void:
	if p_parent_ref != null and p_parent_ref.is_class("Brainiac"):
		parent = p_parent_ref

func _on_tick() -> void:
	pass
