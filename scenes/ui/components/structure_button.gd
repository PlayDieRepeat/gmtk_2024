class_name StructureButton
extends TextureButton

var structure_data: RStructure

@export_group("Child Nodes")
@export var structure_rect: TextureRect
@export var scaffold_rect: TextureRect
@export var name_label: Label

signal structure_selected(p_structure_data: RStructure)

func _ready() -> void:
	assert(structure_rect != null, "structure_rect is null in StructureButton")
	assert(scaffold_rect != null, "scaffold_rect is null in StructureButton")
	assert(name_label != null, "name_label is null in StructureButton")
	assert(structure_data != null, "structure_data is null in StructureButton")
	structure_rect.texture = structure_data.structure_texture
	name_label.text = structure_data.display_name
	focus_entered.connect(_on_button_focused)

func _on_button_focused() -> void:
	structure_selected.emit(structure_data)
