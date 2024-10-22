class_name God
extends Node

signal favor_has_changed(favor: int)
signal favor_cap_reached

@export var god_data: RGod
var favor: int = 0

func _ready() -> void:
	assert(god_data != null, "God resource == null")
	assert(god_data.image != null, "God resource image == null")
	assert(god_data.tithe != null, "God tithe == null")
	add_to_group("Savable", true)

func set_god(p_god: RGod) -> void:
	if p_god != null:
		god_data = p_god

func tithe() -> void:
	if god_data.tithe.stacked_material:
		if god_data.tithe.stack_count:
			favor += god_data.tithe.favor_per_tithe_max
			emit_signal("favor_has_changed", favor)
			if favor >= god_data.favor_cap:
				emit_signal("favor_cap_reached")

func take_material_excess(p_tithe: RMaterialStack) -> void:
	pass
