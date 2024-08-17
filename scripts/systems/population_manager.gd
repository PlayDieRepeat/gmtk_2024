extends Node

@export_group("Starting values")
@export var pop_consts: RPopConstants
var number_of_people: int
var housed_and_unhoused: Array[int]
var hunger_level: int
var fulfillment_level: int
var burn_rate: float
var modifier_stack: Array

func _ready() -> void:
	assert(pop_consts.starting_population >= pop_consts.min_population and pop_consts.starting_population <= pop_consts.max_population, "Population value bad")
	number_of_people = pop_consts.starting_population
	assert(pop_consts.starting_hunger >= pop_consts.min_hunger and pop_consts.starting_hunger <= pop_consts.max_hunger, "Hunger value bad")
	hunger_level = pop_consts.starting_hunger
	assert(pop_consts.starting_fulfillment >= pop_consts.min_fulfillment and pop_consts.starting_fulfillment <= pop_consts.max_fulfillment, "Fulfillment value bad")
	fulfillment_level = pop_consts.starting_fulfillment

func increase_population(p_additional_people: int) -> void:
	var people_summed = number_of_people + p_additional_people
	if people_summed > pop_consts.MAX_POPULATION:
		number_of_people = pop_consts.MAX_POPULATION
	else:
		number_of_people = people_summed

func decrease_population(p_fewer_people: int) -> void:
	var people_differenced = number_of_people - p_fewer_people
	if people_differenced < pop_consts.MIN_POPULATION:
		number_of_people = pop_consts.MIN_POPULATION
	else:
		number_of_people = people_differenced

func get_housed_and_unhoused() -> Array[int] :
	# housing_total: int = Cityster.get_total_housing()
	var housing_total: int = 3 ## TODO: remove magic number and hook into City manager method to query housing details
	if number_of_people <= housing_total: # all can be housed
		return [number_of_people, 0]
	else:
		return [housing_total, number_of_people - housing_total]

func get_hunger_level() -> int:
	return hunger_level

func increase_hunger(p_hunger_value) -> void:
	var hunger_summed = hunger_level + p_hunger_value
	if hunger_summed > pop_consts.MAX_HUNGER:
		hunger_level = pop_consts.MAX_HUNGER
	else:
		hunger_level = hunger_summed

func decrease_hunger(p_hunger_value) -> void:
	var hunger_diffed = hunger_level - p_hunger_value
	if hunger_diffed < pop_consts.MIN_HUNGER:
		hunger_level = pop_consts.MIN_HUNGER
	else:
		hunger_level = hunger_diffed

func get_fulfillment() -> int:
	return fulfillment_level

func increase_fulfillment(p_fulfillment_value) -> void:
	var fulfillment_summed = fulfillment_level + p_fulfillment_value
	if fulfillment_summed > pop_consts.MAX_FULFILLMENT:
		fulfillment_level = pop_consts.MAX_FULFILLMENT
	else:
		fulfillment_level = fulfillment_summed

func decrease_fulfillment(p_fulfillment_value) -> void:
	var fulfillment_diffed = fulfillment_level - p_fulfillment_value
	if fulfillment_diffed < pop_consts.MIN_FULFILLMENT:
		fulfillment_level = pop_consts.MIN_FULFILLMENT
	else:
		fulfillment_level = fulfillment_diffed
