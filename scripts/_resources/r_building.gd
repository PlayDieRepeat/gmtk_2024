extends Resource
class_name RBuilding

@export var grid_width: int
@export var grid_height: int
@export var building_texture: Texture2D
@export var construction_texture: Texture2D
@export var teardown_texture: Texture2D
@export var terrain_requirement: RTerrainType
@export var material_requirements: Array[RMaterialStack]
@export var can_build_above: bool
@export var time_to_build: int

func _init(p_grid_width := 0, p_grid_height := 0, p_texutre = null, p_terrain_requirement = null,
 p_can_build_above = false, p_time_to_build = 0, p_construction_texture = null) -> void:
	grid_width = p_grid_width
	grid_height = p_grid_height
	building_texture = p_texutre
	terrain_requirement = p_terrain_requirement
	construction_texture = p_construction_texture
	can_build_above = p_can_build_above
	time_to_build = p_time_to_build
