extends Resource
class_name RMaterialStack

@export var stacked_material: RMaterial
@export var stack_count: int

func _init(p_stacked_material = null, p_stack_count = 0) -> void:
	stacked_material = p_stacked_material
	stack_count = p_stack_count
