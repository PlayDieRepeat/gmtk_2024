extends Resource
class_name RScene
## RScene is a special resource consisting of a PackedScene and Scene ID.  This resource may grow to contain more data
## Necessary for scene loading depending on the project.

@export var scene: PackedScene
@export var scene_id: String
@export var scene_is_pausable:= true
@export var is_game_scene:= true

func _init(p_scene: PackedScene = null, p_scene_id:= "", p_scene_is_pausable := true, p_is_game_scene := true) -> void:
	scene = p_scene
	scene_id = p_scene_id
	scene_is_pausable = p_scene_is_pausable
	is_game_scene = p_is_game_scene
