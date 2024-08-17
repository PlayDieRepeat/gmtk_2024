extends Resource
class_name RScene
## RScene is a special resource consisting of a PackedScene and Scene ID.  This resource may grow to contain more data
## Necessary for scene loading depending on the project.

@export var scene: PackedScene
@export var scene_id: String

func _init(p_scene: PackedScene = null, p_scene_id:= "") -> void:
	scene = p_scene
	scene_id = p_scene_id
