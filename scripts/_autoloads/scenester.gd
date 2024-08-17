extends Node
## Scenester is an autoloader class that handles scene loading, unloading and tradnsitions.  Any leading loading can be
## handled by calLing swith_scene and passing an RSCene resource.
## TODO: We should really get a loading screen fade in here.

signal loading_progress_changed(progress)
signal loading_done

@export var main_menu_scene: RScene
@export var initial_scene: RScene
var current_scene_id:= ""
var current_scene= null
var _loading_screen_path: String = "res://scenes/systems/loading_screen.tscn"
var _loading_screen= load(_loading_screen_path)
var _target_scene: RScene
var _target_scene_loaded: PackedScene
var _progress: Array = []
var use_sub_threads: bool= true

## Asserts that there is at least a main menu scene, also checks if there is an initial scene, and if not sets it to the
## main Menu scene.  Sets the current scene to whatever is currentl] in the scene.
func _ready() -> void:
	assert(main_menu_scene != null,"Main menu scene is not set")
	if initial_scene == null:
		initial_scene= main_menu_scene
	var root := get_tree().root
	current_scene= root.get_child(root.get_child_count() -1)
	set_process(false)
	
# Returns the id of the current scene
func get_curren_scene_id() -> String:
	return current_scene_id

## Loads the initial scene
func load_initial_scene() -> void:
	call_deferred("_deferred_switch_scene", initial_scene)

# Switch to a scene based on its id
# 	p_scene_id: The scene id to switch to
func switch_scene(p_scene: RScene) -> void:
	call_deferred("_deferred_switch_scene", p_scene)

func _deferred_switch_scene(p_scene: RScene):
	if current_scene != null:
		current_scene.free()
	# set up the new loading screen, add to tree, and connect signal callbacks
	# wait for the loading screen to finish, then start to load target scene
	var new_loading_screen= _loading_screen.instantiate()
	get_tree().get_root().add_child(new_loading_screen)
	self.loading_progress_changed.connect(new_loading_screen._update_progress_bar)
	self.loading_done.connect(new_loading_screen._start_outro_animation)
	await Signal(new_loading_screen, "loading_screen_has_full_coverage")
	current_scene= new_loading_screen
	current_scene_id= "LoadingScreen"
	start_load(p_scene)
	#var scene_to_load= ResourceLoader.load(p_scene.scene.get_path())
	#get_tree().root.add_child(current_scene)
	#get_tree().current_scene = current_scene

func start_load(_scene_to_load: RScene) -> void:
	_target_scene= _scene_to_load
	var state= ResourceLoader.load_threaded_request(_target_scene.scene.get_path(), "", use_sub_threads)
	if state == OK:
		set_process(true)

# Restart the current scene
func restart_scene() -> void:
	get_tree().reload_current_scene()

# Quit the game
func quit_game() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	var load_status= ResourceLoader.load_threaded_get_status(_target_scene.scene.get_path(), _progress)
	match load_status:
		0, 2: #? THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: #? THREAD_LOAD_IN_PROGRESS
			emit_signal("loading_progress_changed", _progress[0])
		3: #? THREAD_LOAD_LOADED
			_target_scene_loaded= ResourceLoader.load_threaded_get(_target_scene.scene.get_path())
			emit_signal("loading_progress_changed", 1.0)
			emit_signal("loading_done")
			get_tree().change_scene_to_packed(_target_scene_loaded)
			current_scene_id= _target_scene.scene_id
