extends HBoxContainer
class_name MaterialDisplay

@export var material_data: RMaterial
@export var icon_rect: TextureRect
@export var material_label: Label
@export var amount_label: Label
@export var add_button: Button
@export var remove_button: Button

signal add_material(material: RMaterial, amount: int)
signal remove_material(material: RMaterial, amount: int)

func _ready():
	if material_data.icon != null:
		icon_rect.texture = material_data.icon
	material_label.text = material_data.display_name + ":"

	add_button.pressed.connect(_on_add_clicked)
	remove_button.pressed.connect(_on_remove_clicked)

func _on_add_clicked() -> void:
	add_material.emit(material_data, 1)

func _on_remove_clicked() -> void:
	remove_material.emit(material_data, 1)

func _on_amount_updated(p_material: RMaterial, p_new_value: int, _p_old_value: int) -> void:
	if p_material.id == material_data.id:
		amount_label.text = "%d" % p_new_value
