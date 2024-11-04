extends Resource
class_name RStructure

## The name display name for this structure type
@export var display_name: String
## Describe how the structure is used
@export var description: String
## Texture2D for this particular structure
@export var structure_texture: Texture2D
## Sets a required terrain type to allow this structure to be built
@export var terrain_requirement: RTerrainType
## A list of required material stacks needed to build this structure.
##
## MAX 4 entries
@export var material_requirements: Array[RMaterialStack]
## Whether additional structures can be built up above this structure
@export var can_build_above: bool
## Time in ticks to build this structure
@export var time_to_build: int

func _init(p_display_name := "", p_description := "", p_texture: Texture2D = null, p_terrain_requirement: RTerrainType = null,
p_can_build_above := false, p_time_to_build := 0) -> void:
	display_name = p_display_name
	description = p_description
	structure_texture = p_texture
	terrain_requirement = p_terrain_requirement
	can_build_above = p_can_build_above
	time_to_build = p_time_to_build