extends Panel
class_name BuildMenu

@export var availabile_buildings: Array[RBuilding]
@export_group("Building Buttons")
@export var building_button: PackedScene
@export var building_buttton_container: HBoxContainer
@export_group("Details Pane")
@export var cost_grid: GridContainer
@export var cost_control: HBoxContainer
@export var usage_label: Label
@export_group("Primary Buttons")
@export var close_button: Button
@export var action_button: Button

signal build_pressed(p_selected_building: RBuilding)
signal building_selected(p_selected_building: RBuilding)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_close_pressed() -> void:
	queue_free()

func _on_action_pressed() -> void:
	pass # Replace with function body.
