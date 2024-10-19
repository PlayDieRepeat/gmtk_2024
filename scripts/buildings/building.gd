extends Node2D
class_name Building

@export_group("Building Data")
@export var is_prebuilt := false
@export var building_data: RBuilding
@export var building_states: Array[PackedScene]

@export_group("Child Nodes")
@export var building_sprite: Sprite2D
@export var scaffold_sprite: Sprite2D
@export var flag: Flag
@export var progress_bar: ProgressBar
@export var waiting_dots: AnimatedSprite2D
@export var state_machine: FiniteStateMachine
@export var build_button: TextureButton

@export_group("Tree References")
@export var metropolis: Metropolis

var left_neighbor: Building = null
var right_neighbor: Building = null
var grid_coordinates := Vector2i(0, 0)
var build_progress := 0
var world_timer: Timer

signal build_button_pressed(p_building: RBuilding)

func _ready() -> void:
	assert(metropolis != null, "No reference to Metropolis")
	world_timer = get_tree().get_first_node_in_group("world_timer")
	assert(world_timer != null, "No reference to World Timer")
	_generate_states()
	if building_data == null:
		state_machine.change_state("Empty")
	else:
		state_machine.change_state("Waiting")

func _generate_states() -> void:
	for state in building_states:
		var state_instance = state.instantiate()
		state_instance.parent_building = self
		state_machine.add_child(state_instance)

func set_building_name() -> void:
	name = "%s_%s#" % [grid_coordinates.x, grid_coordinates.y]
	if building_data != null:
		name += "%s" % building_data.resource_path.get_file().trim_suffix("tres").capitalize()
	name += "%s" % state_machine.current_state.name

func try_get_requirements() -> bool:
	return metropolis.try_get_materials(building_data.material_requirements)

func check_construction_progress() -> bool:
	build_progress += 1
	progress_bar.value = build_progress
	return build_progress >= building_data.time_to_build

func show_progress_bar(p_should_show: bool) -> void:
	build_progress = 0
	progress_bar.value = build_progress
	if p_should_show:
		progress_bar.set_max(building_data.time_to_build)
		progress_bar.visible = true
	else:
		progress_bar.visible = false
		
func show_waiting_dots(p_should_show: bool) -> void:
	if p_should_show:
		waiting_dots.visible = true
		waiting_dots.play()
	else:
		waiting_dots.visible = false
		waiting_dots.stop()

func show_build_button(p_should_show: bool) -> void:
	if p_should_show:
		build_button.disabled = false
	else:
		build_button.disabled = true

func show_building_texture(p_should_show: bool) -> void:
	if p_should_show:
		building_sprite.texture = building_data.building_texture
		building_sprite.visible = true
	else:
		building_sprite.visible = false
		building_sprite.texture = null

func show_building_flag(p_should_show: bool) -> void:
	if p_should_show:
		flag.visible = true
	else:
		flag.visible = false

func show_scaffolding(p_should_show: bool) -> void:
	if p_should_show:
		scaffold_sprite.visible = true
	else:
		scaffold_sprite.visible = false

func add_to_waiting_queue() -> void:
	metropolis.waiting_queue.append(self)

func fade_building(p_should_fade: bool) -> void:
	if p_should_fade:
		modulate = Color(1, 1, 1, .5)
	else:
		modulate = Color(1, 1, 1, 1)

func try_add_neighbor() -> void:
	if left_neighbor == null:
		left_neighbor = metropolis.add_neighbor(Vector2(position.x - scaffold_sprite.texture.get_width(), position.y))
		left_neighbor.right_neighbor = self
		left_neighbor.grid_coordinates = grid_coordinates + Vector2i(-1, 0)
		# left_neighbor.name = "Building_%s_%s" % [left_neighbor.grid_coordinates.x, left_neighbor.grid_coordinates.y]
	if right_neighbor == null:
		right_neighbor = metropolis.add_neighbor(Vector2(position.x + scaffold_sprite.texture.get_width(), position.y))
		right_neighbor.left_neighbor = self
		right_neighbor.grid_coordinates = grid_coordinates + Vector2i(1, 0)
		# right_neighbor.name = "Building_%s_%s" % [right_neighbor.grid_coordinates.x, right_neighbor.grid_coordinates.y]

func _on_build_button_pressed() -> void:
	state_machine.change_state("Menu")
	build_button_pressed.emit(self)

func _on_building_selected(p_building_data: RBuilding) -> void:
	building_data = p_building_data
	show_building_texture(true)
	show_scaffolding(true)

func _on_menu_canceled() -> void:
	state_machine.change_state("Empty")

func _on_build_confirmed() -> void:
	state_machine.change_state("Waiting")
