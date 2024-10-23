extends Resource

class_name	RGrid

@export var position: Vector2 = Vector2.ZERO
@export var size: Vector2 = Vector2(4.0, 4.0)
@export var terrain: Dictionary = {}

func _init(p_position: Vector2 = Vector2.ZERO, p_size: Vector2 = Vector2.ZERO,
p_terrain: Dictionary = {}) -> void:
	position = p_position
	size = p_size
	terrain = p_terrain
