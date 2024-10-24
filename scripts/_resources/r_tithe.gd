extends RMaterialStack

class_name RTithe

@export var favor_per_tithe_min: int = 0
@export var favor_per_tithe_mid: int = 0
@export var favor_per_tithe_max: int = 0

func _init(p_favor_per_tithe_min: int = 0, p_favor_per_tithe_mid: int = 0, p_favor_per_tithe_max: int = 0) -> void:
	favor_per_tithe_min = p_favor_per_tithe_min
	favor_per_tithe_mid = p_favor_per_tithe_mid
	favor_per_tithe_max = p_favor_per_tithe_max
