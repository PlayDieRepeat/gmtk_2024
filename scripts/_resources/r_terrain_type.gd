extends Resource
class_name RTerrainType

@export var id: String
@export var display_name: String

func _init(p_id = "", p_display_name = "") -> void:
	id = p_id
	display_name = p_display_name
