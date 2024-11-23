extends StateMachineState
class_name GUIState

# Reference to the character node.
@export var parent_ref: GUILayer

func _init(p_parent_ref: GUILayer = null) -> void:
	if p_parent_ref != null and p_parent_ref.is_class("GUILayer"):
		parent_ref = p_parent_ref

func _on_tick() -> void:
	pass
