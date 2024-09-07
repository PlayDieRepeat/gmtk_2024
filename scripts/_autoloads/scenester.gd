extends Node
## Scenester is an autoloader class that handles scene loading, unloading and transitions.  
## Loading can be handled by calLing swith_scene and passing an RSCene resource, 
## with a bool flag to determine if a loading screen is needed as a transition .

signal loading_progress_changed(progress)
signal loading_done
signal scene_has_changed(p_scene: String)

@export_group("Special Scenes")
@export var main_menu_rscene: RScene
@export var pause_rscene: RScene
@export var load_rscene: RScene
@export var reconnect_rscene: RScene
@export var initial_rscene: RScene
@export var should_load_initial_alt: bool = false
@export var pause_menu: PackedScene = null
var current_scene_id := ""
var current_scene: Node = null
var game_scene_id := ""
var game_scene: Node = null
var new_scene_to_load: RScene
var new_loaded_scene: PackedScene
var load_progress: Array = []
var use_sub_threads_when_loading: bool = true
var loading_screen_initialized := false

## Asserts that there is at least a main menu scene, also checks if there is an initial scene, and if not sets it to the
## main Menu scene.  Sets the current scene to whatever is currently in the scene.
func _ready() -> void:
	assert(main_menu_rscene != null,"Main menu scene is not set")
	assert(pause_rscene != null,"Pause menu scene is not set")
	assert(load_rscene != null,"Load scene is not set")
	assert(reconnect_rscene != null,"Reconnect menu scene is not set")
	
	if should_load_initial_alt == true:
		assert(initial_rscene != null, "Initial scene is not set")
		if initial_rscene.is_game_scene:
			Brainiac.set_game_state()
		else:
			Brainiac.set_menu_state()
	else:
		initial_rscene = main_menu_rscene
		Brainiac.set_menu_state()
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() -1)
	set_process(false)
	
func get_current_scene_id() -> String:
	return current_scene_id

func get_current_scene() -> Node:
	return current_scene

func load_initial_scene() -> void:
	call_deferred("_deferred_switch_scene", initial_rscene, false)

# Switch to a scene based on its id
# 	p_scene_id: The scene id to switch to
func switch_scene(p_scene: RScene, p_needs_to_load: bool, p_should_free_current: bool = true) -> void:
	call_deferred("_deferred_switch_scene", p_scene, p_needs_to_load, p_should_free_current)

func _deferred_switch_scene(p_scene: RScene, p_needs_to_load: bool, p_should_free_current: bool = true) -> void:
	if p_should_free_current == true:
		if current_scene != null:
			get_tree().get_root().remove_child(current_scene)
			current_scene.queue_free()
	
	if p_needs_to_load == true:
		# set up the new loading screen, add to tree, and connect signal callbacks
		# wait for the loading screen to finish, then start to load target scene
		load_and_add_as_current(load_rscene)
		check_scene_and_change_state(load_rscene)
		_setup_loading_screen()
		_start_background_load(p_scene)
	else:
		load_and_add_as_current(p_scene)
		check_scene_and_change_state(p_scene)
	scene_has_changed.emit(current_scene.to_string())

func check_scene_and_change_state(p_scene: RScene) -> void:
	if p_scene.is_game_scene == true:
		game_scene_id = current_scene_id
		game_scene = current_scene
		Brainiac.set_game_state()
	else:
		match p_scene.scene_id:
			"PauseMenu":
				Brainiac.set_pause_state()
			"ReconnectMenu":
				Brainiac.set_reconnect_state()
			"LoadingScene":
				Brainiac.set_transitional_state()
			_:
				Brainiac.set_menu_state()

func load_and_add_as_current(p_scene: RScene) -> void:
	var loaded_scene = ResourceLoader.load(p_scene.scene.get_path())
	add_loaded_as_current(loaded_scene, p_scene.scene_id)

func add_loaded_as_current(p_scene: PackedScene, p_scene_id: String) -> void:
	current_scene = p_scene.instantiate()
	current_scene.connect("tree_entered", _on_new_scene_entered_tree)
	get_tree().get_root().add_child(current_scene)
	current_scene_id = p_scene_id
 
func _on_new_scene_entered_tree() -> void:
	get_tree().set_current_scene(current_scene)

func pause_for_controller_reconnection() -> void:
	pass

func pause_scene() -> void:
	call_deferred("_setup_pause_screen")

func unpause_scene() -> void:
	call_deferred("_remove_pause_screen")

func _setup_loading_screen() -> void:
	self.loading_progress_changed.connect(current_scene._update_progress_bar)
	self.loading_done.connect(current_scene._start_outro_animation)
	await Signal(current_scene, "loading_screen_has_full_coverage")
	loading_screen_initialized = true

func _setup_pause_screen() -> void:
	_deferred_switch_scene(pause_rscene, false, false)
	var backButton: Button = current_scene.find_child("BackButton")
	var quitButton: Button = current_scene.find_child("QuitButton")
	backButton.connect("pressed", _on_BackButton_pressed)
	quitButton.connect("pressed", _on_QuitButton_pressed)

func _remove_pause_screen() -> void:
	get_tree().get_root().remove_child(current_scene)
	current_scene.queue_free()
	current_scene = game_scene
	current_scene_id = game_scene_id
	Brainiac.set_game_state()

func _start_background_load(p_scene: RScene) -> void:
	new_scene_to_load = p_scene
	assert(new_scene_to_load.scene != null, "Big Problem!!")
	var state = ResourceLoader.load_threaded_request(new_scene_to_load.scene.get_path(), "", use_sub_threads_when_loading)
	if state == OK:
		set_process(true)

func restart_scene() -> void:
	get_tree().reload_current_scene()

func quit_game() -> void:
	get_tree().quit()

func _on_BackButton_pressed() -> void:
	_remove_pause_screen()
	# TODO: setup a check to go back, or additionally auto-save here
	switch_scene(main_menu_rscene, false, true)

func _on_QuitButton_pressed() -> void:
	call_deferred("quit_game")

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(new_scene_to_load.scene.get_path(), load_progress)
	match load_status:
		0, 2: #? THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: #? THREAD_LOAD_IN_PROGRESS
			emit_signal("loading_progress_changed", load_progress[0])
		3: #? THREAD_LOAD_LOADED
			if loading_screen_initialized == true:
				new_loaded_scene = ResourceLoader.load_threaded_get(new_scene_to_load.scene.get_path())
				emit_signal("loading_progress_changed", 1.0)
				emit_signal("loading_done")
				await Signal(current_scene, "loading_outro_finished")
				if current_scene_id == "LoadingScene":
					if current_scene != null:
						get_tree().get_root().remove_child(current_scene)
						current_scene.queue_free()
				add_loaded_as_current(new_loaded_scene, new_scene_to_load.scene_id)
				check_scene_and_change_state(new_scene_to_load)
				set_process(false)
