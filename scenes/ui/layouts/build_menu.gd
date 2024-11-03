extends Panel
class_name BuildMenu

@export_group("Component References")
@export var structure_button: PackedScene
@export var cost_control: PackedScene

@export_group("Child Nodes")
@export var structure_button_container: HBoxContainer
@export var cost_grid: GridContainer
@export var usage_label: Label
@export var close_button: Button
@export var action_button: Button

@export_group("Tree References")
@export var material_warehouse: MaterialWarehouse

var active_structure: Structure
var available_structures: Array[RStructure]

signal structure_selected(p_selected_structure: RStructure)
signal menu_canceled()
signal confirm_build()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _clear_build_buttons() -> void:
	for button in structure_button_container.get_children():
		structure_button_container.remove_child(button)
		button.queue_free()

func _clear_cost_controls() -> void:
	for control in cost_grid.get_children():
		cost_grid.remove_child(control)
		control.queue_free()

func _on_close_pressed() -> void:
	_clear_build_buttons()
	menu_canceled.emit()
	_disconnect_signals()
	hide()

func _on_action_pressed() -> void:
	_clear_build_buttons()
	confirm_build.emit()
	_disconnect_signals()
	hide()

func _connect_signals() -> void:
	structure_selected.connect(active_structure._on_structure_selected)
	menu_canceled.connect(active_structure._on_menu_canceled)
	confirm_build.connect(active_structure._on_build_confirmed)

func _disconnect_signals() -> void:
	structure_selected.disconnect(active_structure._on_structure_selected)
	menu_canceled.disconnect(active_structure._on_menu_canceled)
	confirm_build.disconnect(active_structure._on_build_confirmed)

func _on_build_button_pressed(p_structure: Structure, p_available_structures: Array[RStructure]) -> void:
	active_structure = p_structure
	available_structures = p_available_structures
	_connect_signals()
	for i in available_structures.size():
		var button_instance: StructureButton = structure_button.instantiate()
		button_instance.structure_data = available_structures[i]
		button_instance.structure_selected.connect(_on_structure_selected)
		structure_button_container.add_child(button_instance)
		if i == 0:
			button_instance.grab_focus()
	show()

func _on_structure_selected(p_structure_data: RStructure) -> void:
	_clear_cost_controls()
	usage_label.text = p_structure_data.description
	for stack in p_structure_data.material_requirements:
		var cost_instance: MaterialCostControl = cost_control.instantiate()
		cost_instance.material_stack = stack
		cost_instance.set_available(material_warehouse.check_material_stock(stack.stacked_material))
		cost_grid.add_child(cost_instance)
	structure_selected.emit(p_structure_data)