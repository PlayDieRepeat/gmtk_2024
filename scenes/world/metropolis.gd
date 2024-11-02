extends Node
class_name Metropolis

@export_group("City Components")
@export var starting_values: RScenarioValues
@export var building_scene: PackedScene
@export var available_buildings: Array[RStructure]

@export_group("References")
@export var warehouse: MaterialWarehouse

var waiting_queue: Array[Building]
var world_timer: Timer

signal build_button_pressed(p_building: Building, p_available_buildings: Array[RStructure])

func _ready() -> void:
	world_timer = get_tree().get_first_node_in_group("world_timer")
	assert(world_timer != null, "No reference to World Timer")
	world_timer.timeout.connect(_on_tick)

func _on_build_pressed(p_building: Building) -> void:
	build_button_pressed.emit(p_building, available_buildings)

func add_neighbor(p_position: Vector2) -> Node:
	var building_instance := building_scene.instantiate()
	building_instance.position = p_position
	building_instance.metropolis = self
	add_child.call_deferred(building_instance)
	building_instance.build_button_pressed.connect(_on_build_pressed)
	return building_instance

func _on_tick() -> void:
	var new_queue: Array[Building] = []
	for building in waiting_queue:
		if warehouse.try_get_materials(building.building_data.material_requirements):
			building.state_machine.change_state("Construction")
		else:
			new_queue.append(building)
	waiting_queue = new_queue
