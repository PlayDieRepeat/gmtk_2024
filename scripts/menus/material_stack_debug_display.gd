extends Control
class_name MaterialStackDebugControl

@export var material_data: RMaterial
@export var icon_rect: TextureRect
@export var material_label: Label
@export var amount_label: Label
@export var add_button: Button
@export var remove_button: Button

signal debug_change_material(material: RMaterial, amount: int)
func _ready():
	if material_data.icon != null:
		icon_rect.texture = material_data.icon
	material_label.text = material_data.display_name + ":"

	tooltip_text = material_data.display_name

	add_button.pressed.connect(_on_add_clicked)
	remove_button.pressed.connect(_on_remove_clicked)

func _on_add_clicked() -> void:
	debug_change_material.emit(material_data, 1)

func _on_remove_clicked() -> void:
	debug_change_material.emit(material_data, -1)

func update_stack_amount(p_new_value: int) -> void:
	amount_label.text = "%d" % p_new_value
