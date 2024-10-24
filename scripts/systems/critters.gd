extends Node

class_name Critters

## Critters handles debug UI
## UI Components
@export_group("UI Components")
@export var header_panel: PanelContainer
@export var footer_panel: PanelContainer
@export var grid_panels: Array[PanelContainer] = []
@export var grid_labels: Array[RichTextLabel] = []
@export var footer_left_label: RichTextLabel
@export var footer_center_label: RichTextLabel
@export var footer_right_label: RichTextLabel
@export var ui_canvas_layer: CanvasLayer
@export_group("Alpha Options")
@export_range(0.0, 1.0, 0.1) var main_alpha := 0.5
@export_range(0.0, 1.0, 0.1) var header_alpha := 1.0
@export_range(0.0, 1.0, 0.1) var grid_alpha := 0.5
@export_range(0.0, 1.0, 0.1) var footer_alpha := 1.0

enum grid_position {TOP_LEFT, TOP_CENTER, TOP_RIGHT,
					MIDDLE_LEFT, MIDDLE_CENTER, MIDDLE_RIGHT,
					BOTTOM_LEFT, BOTTOM_CENTER, BOTTOM_RIGHT}

# default strings
var footer_left_text:= "FPS: %d"
var footer_center_text:= "State: %s"
var footer_right_text:= "Scene: %s"
var grid_panel_flags: Array[bool] = []

func _ready() -> void:
	assert(header_panel != null, "Header Panel not assigned!")
	assert(footer_panel != null, "Header Panel not assigned!")
	assert(grid_labels.is_empty() != true)
	assert(footer_left_label != null, "Footer Left not assigned!")
	assert(footer_center_label != null, "Footer Center not assigned!")
	assert(footer_right_label != null, "Footer Right not assigned!")
	## used to flag if a panel in the grid container is being used to
	## display a variable. If it is false, it will hide the panel.
	grid_panel_flags = [false, false, false,
				false, false, false,
				false, false, false]
	_set_default_system()
	$UI.visible = false
	Elephant.event_logged.connect(on_debug_event_logged)
	%TickOneSec.timeout.connect(on_tick)
	_get_fps()

func _set_default_system() -> void:
	$UI/MainMargin.modulate = Color(1.0, 1.0, 1.0, main_alpha)
	_set_header_info()
	_set_grid_info()
	_set_footer_info()

func _set_header_info() -> void:
	header_panel.modulate = Color(1.0, 1.0, 1.0, header_alpha)

func _set_grid_info() -> void:
	for i in grid_panels.size():
		grid_panels[i].modulate = Color(1.0, 1.0, 1.0, grid_alpha)

func _set_footer_info() -> void:
	footer_panel.modulate = Color(1.0, 1.0, 1.0, footer_alpha)
	Brainiac.game_state_has_changed.connect(on_state_has_changed)
	var _text = footer_center_text % Brainiac.get_game_state_string()
	footer_center_label.text = _text
	Scenester.scene_has_changed.connect(on_scene_has_changed)

func _get_fps() -> void:
	footer_left_label.text = footer_left_text % Performance.get_monitor(Performance.TIME_FPS)

func on_state_has_changed(p_state: String) -> void:
	footer_center_label.text = footer_center_text % p_state

func on_scene_has_changed(p_scene: String) -> void:
	footer_right_label.text = footer_right_text % p_scene

func on_debug_event_logged(p_event: String) -> void:
	grid_panel_flags[0] = true
	grid_labels[0].text = p_event

func on_tick() -> void:
	_get_fps()

func _process(delta: float) -> void:
	check_grid_panel_visibility()

## TODO: Come up with a better way to couple a panel with some info about it.
## is a Resource the answer here?
## grid_panels.size == grid_panel_flags.size, and they are a 1:1 relationship
func check_grid_panel_visibility() -> void:
	for i in grid_panels.size():
		if grid_panel_flags[i] == true:
			grid_panels[i].visible = true
		else:
			grid_panels[i].visible = false

func display_or_hide_debug_ui() -> void:
	if ui_canvas_layer.visible == false:
		ui_canvas_layer.visible = true
	else:
		ui_canvas_layer.visible = false
