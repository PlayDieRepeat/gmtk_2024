extends Resource
class_name RPopConstants

@export var min_population: int = 3
@export var max_population: int = 50
@export var starting_population: int = -2
@export var min_hunger: int = 0
@export var max_hunger: int = 100
@export var starting_hunger: int = 50
@export var min_fulfillment: int = 0
@export var max_fulfillment: int = 100
@export var starting_fulfillment: int = 2

func _init(p_min_pop := 0, p_max_pop := 0, p_starting_pop := 0, p_min_hunger := 0, 
p_max_hunger := 0, p_starting_hunger := 0, p_min_fulfillment := 0, p_max_fulfillment := 0,
p_starting_fulfillment := 0) -> void:
	min_population = p_min_pop
	max_population = p_max_pop
	starting_population = p_starting_pop
	min_hunger = p_min_hunger
	max_hunger = p_max_hunger
	starting_hunger = p_starting_hunger
	min_fulfillment = p_min_fulfillment
	max_fulfillment = p_max_fulfillment
	starting_fulfillment = p_starting_fulfillment
