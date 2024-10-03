extends Resource
class_name RGod

@export var image: Texture2D = null
@export var passive: String = ""
@export var tithe: RTithe = null

func _init(p_image: Texture2D = null, p_passive: String = "",
p_tithe: RTithe = null, p_favor_cap: int = 0) -> void:
	image = p_image
	passive = p_passive
	tithe = p_tithe
