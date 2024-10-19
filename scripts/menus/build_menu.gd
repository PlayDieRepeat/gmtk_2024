extends Panel
class_name BuildMenu

@export_group("Component References")
@export var building_button: PackedScene
@export var cost_control: PackedScene

@export_group("Child Nodes")
@export var building_button_container: HBoxContainer
@export var cost_grid: GridContainer
@export var usage_label: Label
@export var close_button: Button
@export var action_button: Button

@export_group("Tree References")
@export var material_warehouse: MaterialWarehouse

var active_building: Building
var available_buildings: Array[RBuilding]

signal building_selected(p_selected_building: RBuilding)
signal menu_canceled()
signal confirm_build()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func clear_build_buttons() -> void:
	for button in building_button_container.get_children():
		building_button_container.remove_child(button)
		button.queue_free()

func clear_cost_controls() -> void:
	for control in cost_grid.get_children():
		control.remove_child(control)
		control.queue_free()

func _on_close_pressed() -> void:
	clear_build_buttons()
	menu_canceled.emit()
	disconnect_signals()
	hide()

func _on_action_pressed() -> void:
	clear_build_buttons()
	confirm_build.emit()
	disconnect_signals()
	hide()

func connect_signals() -> void:
	building_selected.connect(active_building._on_building_selected)
	menu_canceled.connect(active_building._on_menu_canceled)
	confirm_build.connect(active_building._on_build_confirmed)

func disconnect_signals() -> void:
	building_selected.disconnect(active_building._on_building_selected)
	menu_canceled.disconnect(active_building._on_menu_canceled)
	confirm_build.disconnect(active_building._on_build_confirmed)

func _on_build_button_pressed(p_building: Building, p_available_buildings: Array[RBuilding]) -> void:
	active_building = p_building
	available_buildings = p_available_buildings
	connect_signals()
	for i in available_buildings.size():
		var button_instance: BuildingButton = building_button.instantiate()
		button_instance.building_data = available_buildings[i]
		button_instance.building_selected.connect(_on_building_selected)
		building_button_container.add_child(button_instance)
		if i == 0:
			button_instance.grab_focus()
	show()

func _on_building_selected(p_building_data: RBuilding) -> void:
	clear_cost_controls()
	usage_label.text = p_building_data.description
	for stack in p_building_data.material_requirements:
		var cost_instance: MaterialCostControl = cost_control.instantiate()
		cost_instance.material_stack = stack
		cost_instance.set_available(material_warehouse.check_material_stock(stack.stacked_material))
		cost_grid.add_child(cost_instance)
	building_selected.emit(p_building_data)