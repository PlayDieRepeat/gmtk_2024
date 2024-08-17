extends Node
## Scenester is an autoloader class that handles scene loading, unloading and transitions.  
## Loading can be handled by calLing swith_scene and passing an RSCene resource, 
## with a bool flag to determine if a loading screen is needed as a transition .

signal loading_progress_changed(progress)
signal loading_done

@export var main_menu_scene: RScene
@export var initial_scene: RScene
var current_scene_id := ""
var current_scene: Node = null
var _loading_screen_path: String = "res://scenes/systems/loading_screen.tscn"
var _loading_screen = load(_loading_screen_path)
var _target_scene: RScene
var _target_scene_loaded: PackedScene
var _progress: Array = []
var use_sub_threads: bool = true

## Asserts that there is at least a main menu scene, also checks if there is an initial scene, and if not sets it to the
## main Menu scene.  Sets the current scene to whatever is currently in the scene.
func _ready() -> void:
	assert(main_menu_scene != null,"Main menu scene is not set")
	if initial_scene == null:
		initial_scene = main_menu_scene
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() -1)
	set_process(false)
	
func get_curren_scene_id() -> String:
	return current_scene_id

func load_initial_scene() -> void:
	call_deferred("_deferred_switch_scene", initial_scene, false)

# Switch to a scene based on its id
# 	p_scene_id: The scene id to switch to
func switch_scene(p_scene: RScene, p_needs_to_load: bool) -> void:
	call_deferred("_deferred_switch_scene", p_scene, p_needs_to_load)

func _deferred_switch_scene(p_scene: RScene, p_needs_to_load: bool):
	if current_scene != null:
		current_scene.free()
	if p_needs_to_load == true:
		# set up the new loading screen, add to tree, and connect signal callbacks
		# wait for the loading screen to finish, then start to load target scene
		setup_loading_screen()
		start_load(p_scene)
	else:
		#current_scene= ResourceLoader.load(p_scene.scene.get_path())
		var loaded_scene = ResourceLoader.load(p_scene.scene.get_path())
		get_tree().change_scene_to_packed(loaded_scene)
		current_scene = get_tree().current_scene

func setup_loading_screen() -> void:
	var new_loading_screen: Node = _loading_screen.instantiate()
	get_tree().get_root().add_child(new_loading_screen)
	self.loading_progress_changed.connect(new_loading_screen._update_progress_bar)
	self.loading_done.connect(new_loading_screen._start_outro_animation)
	await Signal(new_loading_screen, "loading_screen_has_full_coverage")
	current_scene = get_tree().current_scene
	current_scene_id = "LoadingScreen"

func start_load(_scene_to_load: RScene) -> void:
	_target_scene = _scene_to_load
	var state = ResourceLoader.load_threaded_request(_target_scene.scene.get_path(), "", use_sub_threads)
	if state == OK:
		set_process(true)

func restart_scene() -> void:
	get_tree().reload_current_scene()

func quit_game() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(_target_scene.scene.get_path(), _progress)
	match load_status:
		0, 2: #? THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: #? THREAD_LOAD_IN_PROGRESS
			emit_signal("loading_progress_changed", _progress[0])
		3: #? THREAD_LOAD_LOADED
			_target_scene_loaded = ResourceLoader.load_threaded_get(_target_scene.scene.get_path())
			emit_signal("loading_progress_changed", 1.0)
			emit_signal("loading_done")
			get_tree().change_scene_to_packed(_target_scene_loaded)
			current_scene = get_tree().current_scene
			current_scene_id = _target_scene.scene_id
