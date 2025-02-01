@tool
extends Node2D
class_name DynamicTerrain

@export var terrain_type: RTerrainType

@export_group("Textures")
## The different textures that will be used to generate foliage.
@export var placement_textures: Array[Texture2D]
## The initial minimum offset between placements
@export_group("Placement")
@export_range(5, 50) var minimum_offset := 16.0
## How much the minimum offset will change as the layers get closer to the camera
@export_range(10, 100) var minimum_offset_delta := 10.0
## The initial maximum offset between placements
@export_range(5, 100) var maximum_offset := 68.0
## How much the maximum offset will change as the layers get closer to the camera
@export_range(10, 100) var maximum_offset_delta := 20.0
## How much to move in the y vector between layers - smaller means more layers
@export_range(0, 32) var layer_offset := 10.5
## How much to wobble in the y axis within a single layer
@export_range(1, 5) var layer_wobble := 2.0

@export_group("Scaling")
## Minimum amount to scale the layer furthest from the camera 
@export_range(.2, 1) var scale_minimum := .3
## Maximum amount to scale the layer closest to the camera
@export_range(1, 2) var scale_maximum := 1.3
## The weight that we lerp between layers between minimum and maximum
@export_range(0, 1) var lerp_weight := .3
## Amount in either direction to randomly scale placements within a single layer
@export_range(0, .5) var layer_scale_variance := .3

@export_group("References")
@export var terrain_rect: CollisionShape2D

@export_category("Debug")
@export var redraw_placements: bool:
	set(value):
		if value != redraw_placements:
			redraw_placements = value
			if _validate_terrain():
				draw_placements()

func _ready() -> void:
	if _validate_terrain():
		draw_placements()

func _validate_terrain() -> bool:
	var result := true
	if terrain_rect == null:
		result = false
		printerr("Missing a Terrain Rectangle reference")
	if placement_textures.size() < 1:
		result = false
		printerr("No Placement Textures in dynamic terrain")
	if maximum_offset < minimum_offset:
		result = false
		printerr("Maximum offset cannot be less than minimum offset")
	if maximum_offset_delta <= minimum_offset_delta:
		result = false
		printerr("Maximum offset delta cannot be less than or equal to minimum offset delta")
	if scale_maximum < scale_minimum:
		result = false
		printerr("Maximum scale cannot be less than minimum scale")
	return result

func draw_placements() -> void:
	# Check that we're in the placement before trying to do this
	if not is_inside_tree():
		await ready
	# Delete all existing placements
	var old_foliage := get_children()
	for fol in old_foliage:
		if fol.is_in_group("foliage"):
			fol.queue_free()
	# We need a snapshot of the offsets since we're going to screw with them	
	var _minimum_offset := minimum_offset
	var _maximum_offset := maximum_offset
	var terrain_size := terrain_rect.shape.get_rect().size
	var y_position := terrain_size.y
	var scaler := scale_minimum
	# Draw the furthest layer first
	while y_position > 0:
		# Randomly pick a starting position
		var x_position := randf_range(0, minimum_offset)
		# Add placements in a layer:
		while x_position < terrain_size.x:
			# Instantiate a sprite with the basics
			var placement_instance: Sprite2D = Sprite2D.new()
			add_child(placement_instance)
			placement_instance.texture = placement_textures.pick_random()
			placement_instance.offset.y -= placement_instance.texture.get_size().y / 2
			placement_instance.owner = get_tree().edited_scene_root
			placement_instance.add_to_group("foliage")
			# Set the position and scale
			var y_variant := randf_range(1, layer_wobble)
			var scale_variant := randf_range(-layer_scale_variance, layer_scale_variance)
			placement_instance.position = Vector2(x_position, -(y_position - y_variant))
			placement_instance.scale = Vector2(scaler + scale_variant, scaler + scale_variant)
			# Generate the next position
			x_position += randf_range(_minimum_offset, _maximum_offset)
		# Move up and update values
		y_position = clampf(y_position - layer_offset, 0, terrain_size.y)
		scaler = lerpf(scaler, scale_maximum, .4)
		_minimum_offset += minimum_offset_delta
		_maximum_offset += maximum_offset_delta