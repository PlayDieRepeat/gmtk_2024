class_name God
extends Node2D

signal favor_has_changed(favor: int)
signal favor_cap_reached

@export var god_data: RGod
var favor: int = 0

func _ready() -> void:
	assert(god_data != null, "God resource == null")
	assert(god_data.image != null, "God resource image == null")
	assert(god_data.tithe != null, "God tithe == null")

func set_god(p_god: RGod) -> void:
	if p_god != null:
		god_data = p_god

func tithe(p_tithe: RMaterialStack) -> void:
	if p_tithe.stacked_material == god_data.tithe.stacked_material:
		if p_tithe.stack_count >= god_data.tithe.stack_count:
			favor += god_data.tithe.favor_per_tithe_max
			emit_signal("favor_has_changed", favor)
			if favor >= god_data.favor_cap:
				emit_signal("favor_cap_reached")

	# TODO - Move somewhere... maybe god stuff? maybe tithe ui.  Might depend on how we want tithing to happen
	# ie. if it should be daily or hourly
	# var random_tithe: int = randi_range(8, 12)
	# var tithing: RMaterialStack = RMaterialStack.new(villager_mat_cache, random_tithe)
	# ui_tithing.text = ui_tithing_text_ph % tithing.stacked_material.display_name
	# %God.tithe(tithing)

	# func _on_god_favor_has_changed(p_favor: int) -> void:
	# 	ui_favor.text = ui_favor_text_ph % p_favor
