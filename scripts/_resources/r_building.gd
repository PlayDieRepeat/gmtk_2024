extends Resource
class_name RBuilding

@export var grid_width: int
@export var grid_height: int
@export var texture: Texture2D
@export var terrain_requirement: RTerrainType
@export var material_requirements: Array[RMaterialRequirement]
@export var can_build_above: bool

func _init(p_grid_width := 0, p_grid_height := 0, p_texutre = null, p_terrain_requirement = null,
p_material_requirements = null, p_can_build_above = false) -> void:
	grid_width = p_grid_width
	grid_height = p_grid_height
	texture = p_texutre
	terrain_requirement = p_terrain_requirement
	material_requirements = p_material_requirements
	can_build_above = p_can_build_above
