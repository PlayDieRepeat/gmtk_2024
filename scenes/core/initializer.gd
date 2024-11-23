extends Node
class_name Initializer
## The Initializer should always be the first scene used by the game launcher.  This scene will check to make sure any
## autoloads are ready and then load the initial scene set in the Scenester.  If you're iterating on a different scene
## locally, you can add it here and set the override to true to load that instead.
## IMPORTANT :: ALL Autoloads should be hooked up here (ideally we could do this automatically)

@export_group("Scene Override Options")
@export var scene_override: RScene
@export var use_override: bool

var ready_to_start_game := false

func _process(_delta: float) -> void:
	if ready_to_start_game == true:
		return
	
	if (SoundManager.has_loaded == true) and (MusicManager.has_loaded == true) and (AudioBankRobber.has_loaded == true):
		ready_to_start_game = true
		if (use_override == true) and (scene_override != null):
			Scenester.switch_scene(scene_override, false)
		else:
			Scenester.load_initial_scene()
