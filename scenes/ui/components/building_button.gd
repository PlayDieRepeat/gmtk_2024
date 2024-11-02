class_name BuildingButton
extends TextureButton

var building_data: RStructure

@export_group("Child Nodes")
@export var building_rect: TextureRect
@export var scaffold_rect: TextureRect
@export var name_label: Label

signal building_selected(p_building_data: RStructure)

func _ready() -> void:
	assert(building_rect != null, "building_rect is null in BuildingButton")
	assert(scaffold_rect != null, "scaffold_rect is null in BuildingButton")
	assert(name_label != null, "name_label is null in BuildingButton")
	assert(building_data != null, "building_data is null in BuildingButton")
	building_rect.texture = building_data.building_texture
	name_label.text = building_data.display_name
	focus_entered.connect(_on_button_focused)

func _on_button_focused() -> void:
	building_selected.emit(building_data)
