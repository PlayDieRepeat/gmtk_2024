extends Control

@export var material_display_control: PackedScene
var controls: Array[MaterialStackDebugControl] = []

signal debug_add_material(p_material: RMaterial, p_amount: int)
signal debug_remove_material(p_material: RMaterial, p_amount: int)

func _on_debug_change_materal(p_material: RMaterial, p_amount: int):
	if p_amount > 0:
		debug_add_material.emit(p_material, 1)
	else:
		debug_remove_material.emit(p_material, 1)

func _on_initiliaze_control(p_stacks: Array[MaterialStack]) -> void:
	for stack in p_stacks:
		var control_instance = material_display_control.instantiate()
		control_instance.material_data = stack.stacked_material
		control_instance.update_stack_amount(stack.stack_count)
		add_child(control_instance)
		control_instance.name = stack.stacked_material.display_name
		control_instance.debug_change_material.connect(_on_debug_change_materal)
		controls.append(control_instance)


func _on_material_stack_changed(p_material: RMaterial, p_new_value: int, _p_old_value: int) -> void:
	for control in controls:
		if control.material_data == p_material:
			control.update_stack_amount(p_new_value)
