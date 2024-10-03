extends Node2D
class_name Building

@export_group("Buidling Data")
@export var is_prebuilt := false
@export var building_data: RBuilding
@export var building_states: Array[PackedScene]

@export_group("Building Components")
@export var building_texture: TextureRect
@export var progress_bar: ProgressBar
@export var waiting_dots: AnimatedSprite2D
@export var state_machine: FiniteStateMachine
@export var build_button: TextureButton

@export var metropolis: Metropolis
var left_neighbor: Building = null
var right_neighbor: Building = null
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
	elif is_prebuilt:
		state_machine.change_state("Open")
	else:
		state_machine.change_state("Waiting")
		metropolis.waiting_queue.append(self)

func _generate_states() -> void:
	for state in building_states:
		var state_instance = state.instantiate()
		state_instance.parent_building = self
		state_machine.add_child(state_instance)

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
		build_button.visible = true
		build_button.disabled = false
	else:
		build_button.visible = false
		build_button.disabled = true

func set_building_texture(p_texture: Texture2D) -> void:
	building_texture.texture = p_texture

func check_neighbors() -> void:
	if left_neighbor == null:
		left_neighbor = metropolis.add_neighbor(Vector2(position.x - building_texture.size.x, position.y))
		left_neighbor.right_neighbor = self
		left_neighbor.name = "LeftSocket"
	if right_neighbor == null:
		right_neighbor = metropolis.add_neighbor(Vector2(position.x + building_texture.size.x, position.y))
		right_neighbor.left_neighbor = self
		right_neighbor.name = "RightSocket"

func _on_building_rect_mouse_exited() -> void:
	if state_machine.current_state.name == "Empty":
		show_build_button(false)

func _on_building_rect_mouse_entered() -> void:
	if state_machine.current_state.name == "Empty":
		show_build_button(true)

func _on_build_button_pressed() -> void:
	build_button_pressed.emit(self)
