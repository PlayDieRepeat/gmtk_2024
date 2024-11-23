class_name GUILayer
extends CanvasLayer

@export var gui_states: Array[PackedScene]

@export_category("Child References")
@export var fsm: FiniteStateMachine
@export var glass_wall: Control
@export var build_menu: BuildMenu
@export var eod_card: EndOfDayCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_states()
	fsm.change_state("Default")
	build_menu.menu_canceled.connect(_on_build_menu_closed)
	eod_card.card_closed.connect(_on_eod_closed)

func _generate_states() -> void:
	for state in gui_states:
		var state_instance = state.instantiate()
		state_instance.parent_ref = self
		fsm.add_child(state_instance)

func _enable_glass_wall(p_enable: bool) -> void:
	glass_wall.visible = p_enable
	if p_enable:
		print("Glass Wall Up")
	else:
		print("Glass Wall Down")

func _on_open_build_menu(p_building: Structure, p_available_buildings: Array[RStructure]) -> void:
	fsm.change_state("BuildMenu")
	build_menu.open_build_menu(p_building, p_available_buildings)

func _on_open_end_of_day(_p_new_day: int, _p_old_day: int, _p_time_constants: RTimeConstants) -> void:
	fsm.change_state("EOD")
	eod_card.show_card()

func _on_build_menu_closed() -> void:
	fsm.change_state("Default")

func _on_eod_closed() -> void:
	fsm.change_state("Default")