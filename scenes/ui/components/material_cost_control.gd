class_name MaterialCostControl
extends Control

@export_group("Child Nodes")
@export var material_icon: TextureRect
@export var cost_label: Label
@export var available_label: Label

var material_stack: RMaterialStack

func _ready():
	assert(material_icon != null, "material_icon is null in MaterialCostControl")
	assert(cost_label != null, "cost_label is null in MaterialCostControl")
	assert(available_label != null, "available_label is null in MaterialCostControl")
	assert(material_stack != null, "material_stack is null in MaterialCostControl")
	material_icon.texture = material_stack.stacked_material.icon
	cost_label.text = "%s" % material_stack.stack_count

## This is to force a merge
func set_available(p_stock: int) -> void:
	available_label.text = "(%s)" % p_stock