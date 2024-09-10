extends Resource
class_name RMaterialRequirement

@export var material: RMaterial = null
@export var count: int = 0

func _init(p_material = null, p_count = 0) -> void:
	material = p_material
	count = p_count
