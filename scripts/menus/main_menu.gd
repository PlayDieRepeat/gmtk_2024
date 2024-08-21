extends Node
class_name MainMenu
## The MainMenu is the primary UI scene.  This scene handles the primary menu switching and button logic.  Any new menu
## scenes that are not run during gameplay should be hooked up here.

@export_group("Menu Sub Scenes")
@export var start_menu_packed_scene: PackedScene
@export var credits_menu_packed_scene: PackedScene
@export var options_menu_packed_scene: PackedScene

@export_group("Game Scenes")
@export var game_scene: RScene

var current_sub_menu_instance: Control
var button_hover_sfx_instance: PooledAudioStreamPlayer
var button_click_sfx_instance: PooledAudioStreamPlayer

func _ready() -> void:
	# We reserve sfx player instances so that we can play these sounds back monophonically
	button_hover_sfx_instance = SoundManager.instance("ui", "ui_bloop", "UI Sounds")
	button_click_sfx_instance = SoundManager.instance("ui", "ui_bloop", "UI Sounds")
	# Load the start menu by default
	_ready_start_menu()

## Instantiate the start menu and maps its buttons to the appropriate events
func _ready_start_menu() -> void: 
	_instantiate_sub_menu(start_menu_packed_scene)
	current_sub_menu_instance.connect("start_button_pressed", _on_start_game)
	current_sub_menu_instance.connect("credits_button_pressed", _on_go_to_credits)
	current_sub_menu_instance.connect("options_button_pressed", _on_go_to_options)
	current_sub_menu_instance.connect("quit_button_pressed", _on_quit)

## Instantiate the credits menu and maps its buttons to the appropriate events
func _ready_credits_menu() -> void:
	_instantiate_sub_menu(credits_menu_packed_scene)
	current_sub_menu_instance.connect("back_to_start", _on_return_to_start)

## Instantiate the options menu and maps its buttons to the appropriate events
func _ready_options_menu() -> void:
	_instantiate_sub_menu(options_menu_packed_scene)
	current_sub_menu_instance.connect("back_to_start_from_options", _on_return_to_start)

## Handles actual menu instantiaion, registering button sfx, and cleaning up the previous menu
func _instantiate_sub_menu(p_sub_menU_scene: PackedScene) -> void:
	if current_sub_menu_instance != null:
		remove_child(current_sub_menu_instance)
	current_sub_menu_instance = p_sub_menU_scene.instantiate()
	add_child(current_sub_menu_instance)
	_register_button_ui_sounds()
	
## Connects any control in the "Buttons" groups to the necessary events for sfx sounds.
func _register_button_ui_sounds() -> void:
	for child in get_tree().get_nodes_in_group("Buttons"):
		child.connect("mouse_entered", _on_button_mouse_entered)
		child.connect("pressed", _on_button_clicked)

#
# MENU EVENT HOOKS

## Used to the start the game
func _on_start_game() -> void:
	Scenester.switch_scene(game_scene, true)

## Used to go to the credits screen
func _on_go_to_credits() -> void:
	_ready_credits_menu()

## Used to go to the options menU
func _on_go_to_options() -> void:
	_ready_options_menu() 

## Used to return to the start menu
func _on_return_to_start() -> void:
	_ready_start_menu()

## Used to quit the game
func _on_quit() -> void:
	Scenester.quit_game()

## Triggers the hover sfx on mouse enter
func _on_button_mouse_entered() -> void:
	button_hover_sfx_instance.trigger()

## Triggers the click sfx on button pressed
func _on_button_clicked() -> void:
	button_click_sfx_instance.trigger()
