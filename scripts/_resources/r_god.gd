extends Resource
class_name RGod

@export var image: Image = null
@export var passive: String = ""
@export var favor: RMaterialStack = null
@export var tithe: RMaterialStack = null

func _init(p_image: Image = null, p_passive: String = "", p_favor: RMaterialStack = null, p_tithe: RMaterialStack = null) -> void:
	assert(p_image != null)
	image = p_image
	passive = p_passive
	favor = p_favor
	tithe = p_tithe
