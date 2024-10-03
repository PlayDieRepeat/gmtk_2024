class_name PopulationManager
extends Node

@export_group("Starting values")
@export var pop_consts: RPopConstants
@export var warehouse: MaterialWarehouse

var burn_rate: float
var modifier_stack: Array

signal population_changed(material: RMaterial, new_value: int, old_value: int)

func _ready() -> void:
	pass

func get_population() -> int:
	var result := -1
	return result

func increase_population(_p_pop_to_add: int) -> int:
	var result := -1
	return result

func decrease_population(_p_pop_to_remove: int) -> int:
	var result := -1
	return result

func get_housed_and_unhoused() -> Vector2i:
	var result := Vector2i(-1, -1)
	return result

func get_hunger() -> int:
	var result := -1
	return result

func increase_hunger(_p_hunger_to_add: ) -> int:
	var result := -1
	return result

func decrease_hunger(_p_hunger_to_remove: ) -> int:
	var result := -1
	return result

func get_fulfillment() -> int:
	var result := -1
	return result

func increase_fulfillment(_p_fulfillment_to_add: int) -> int:
	var result := -1
	return result

func decrease_fulfillment(_p_fulfillment_to_add: int) -> int:
	var result := -1
	return result
