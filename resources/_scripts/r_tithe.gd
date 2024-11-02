extends Resource
class_name RTithe

@export var tithe_material: RMaterial
@export var tithe_lower_threshold := 0
@export var tithe_middle_threshold := 0
@export var tithe_upper_threshold := 0
@export var favor_per_tithe_min: int = 0
@export var favor_per_tithe_mid: int = 0
@export var favor_per_tithe_max: int = 0

func _init(p_favor_per_tithe_min: int = 0, p_favor_per_tithe_mid: int = 0, p_favor_per_tithe_max: int = 0) -> void:
	favor_per_tithe_min = p_favor_per_tithe_min
	favor_per_tithe_mid = p_favor_per_tithe_mid
	favor_per_tithe_max = p_favor_per_tithe_max
