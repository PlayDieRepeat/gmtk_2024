extends Node2D

signal favor_has_changed(favor: int)
signal favor_cap_reached

@export var god_resource: RGod
var favor: int = 0

func _ready() -> void:
	assert(god_resource != null, "God resource == null")
	assert(god_resource.image != null, "God resource image == null")
	assert(god_resource.tithe != null, "God tithe == null")

func tithe(p_tithe: RMaterialStack) -> void:
	if p_tithe.stacked_material == god_resource.tithe.stacked_material:
		if p_tithe.stack_count >= god_resource.tithe.stack_count:
			favor += god_resource.tithe.favor_per_tithe_max
			emit_signal("favor_has_changed", favor)
			print("Good Tithe!!! I am happy!")
			if favor >= god_resource.favor_cap:
				emit_signal("favor_cap_reached")
