extends Resource
class_name RScenesterConstants

## Reference to the RScene Resource to load before the main menu scene
@export var initial_rscene: RScene

## Reference to the Main Menu RScene Resource used for the main menu
@export var main_menu_rscene: RScene

## If checked, loads to the main menu instead of the initial scene
@export var start_in_main_menu := true

## Reference to the RScene Resource used for the pause screen
@export var pause_rscene: RScene

## Reference to the RScene Resource to use for loading screens
@export var load_rscene: RScene

## Reference to the RScene Resource to use for the reconnect screen
@export var reconnect_rscene: RScene

func _init(
	p_initial: RScene = null,
	p_main_menu: RScene = null,
	p_start_in_main_menu := true,
	p_pause: RScene = null,
	p_load: RScene = null,
	p_reconnect: RScene = null) -> void:
	initial_rscene = p_initial
	main_menu_rscene = p_main_menu
	start_in_main_menu = p_start_in_main_menu
	pause_rscene = p_pause
	load_rscene = p_load
	reconnect_rscene = p_reconnect
