extends Node2D

@export var god_resource: RGod

func _ready() -> void:
	assert(god_resource != null, "God resource == null")
