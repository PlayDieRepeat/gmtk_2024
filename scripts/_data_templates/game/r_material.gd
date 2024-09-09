extends Resource
class_name RMaterial

@export var id: String
@export var display_name: String
@export var icon: Texture2D

func _init(p_icon: Texture2D = null, p_display_name := "", p_id := "") -> void:
	icon = p_icon
	display_name = p_display_name
	id = p_id
