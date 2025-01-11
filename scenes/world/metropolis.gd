extends Node
class_name Metropolis

@export_group("City Components")
@export var starting_values: RScenarioValues
@export var structure_scene: PackedScene
@export var available_structures: Array[RStructure]

@export_group("References")
@export var warehouse: MaterialWarehouse

var waiting_queue: Array[Structure]
var world_timer: Timer

signal build_button_pressed(p_structure: Structure, p_available_structures: Array[RStructure])

func _ready() -> void:
	world_timer = get_tree().get_first_node_in_group("world_timer")
	assert(world_timer != null, "No reference to World Timer")
	world_timer.timeout.connect(_on_tick)

func _on_build_pressed(p_structure: Structure) -> void:
	build_button_pressed.emit(p_structure, available_structures)

func add_neighbor(p_position: Vector2) -> Node:
	var structure_instance := structure_scene.instantiate()
	structure_instance.position = p_position
	structure_instance.metropolis = self
	add_child.call_deferred(structure_instance)
	structure_instance.build_button_pressed.connect(_on_build_pressed)
	return structure_instance

func _on_tick() -> void:
	var new_queue: Array[Structure] = []
	for structure in waiting_queue:
		if warehouse.try_get_materials(structure.structure_data.material_requirements):
			structure.state_machine.change_state("Construction")
		else:
			new_queue.append(structure)
	waiting_queue = new_queue
