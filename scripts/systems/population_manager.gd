extends Node

const MIN_POPULATION = 3
const MAX_POPULATION = 50
const MIN_HUNGER = 0
const MAX_HUNGER = 100
const MIN_FULFILLMENT = 0
const MAX_FULFILLMENT = 100

@export_group("Starting values")
@export var starting_population: int = MIN_POPULATION
@export var starting_housed: int = MIN_POPULATION
@export var starting_hunger: int = MIN_HUNGER
@export var starting_fulfillment: int = MIN_FULFILLMENT
var number_of_people: int = starting_population
var housed_and_unhoused: Array[int] = [starting_housed, starting_population - starting_housed]
var hunger_level: int = starting_hunger
var fulfillment_level: int = starting_fulfillment
var burn_rate: float = 0.0
var modifier_stack: Array = []

func increase_population(p_additional_people: int) -> void:
	var people_summed = number_of_people + p_additional_people
	if people_summed > MAX_POPULATION:
		number_of_people = MAX_POPULATION
	else:
		number_of_people = people_summed

func decrease_population(p_fewer_people: int) -> void:
	var people_differenced = number_of_people - p_fewer_people
	if people_differenced < MIN_POPULATION:
		number_of_people = MIN_POPULATION
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
	if hunger_summed > MAX_HUNGER:
		hunger_level = MAX_HUNGER
	else:
		hunger_level = hunger_summed

func decrease_hunger(p_hunger_value) -> void:
	var hunger_diffed = hunger_level - p_hunger_value
	if hunger_diffed < MIN_HUNGER:
		hunger_level = MIN_HUNGER
	else:
		hunger_level = hunger_diffed

func get_fulfillment() -> int:
	return fulfillment_level

func increase_fulfillment(p_fulfillment_value) -> void:
	var fulfillment_summed = fulfillment_level + p_fulfillment_value
	if fulfillment_summed > MAX_FULFILLMENT:
		fulfillment_level = MAX_FULFILLMENT
	else:
		fulfillment_level = fulfillment_summed

func decrease_fulfillment(p_fulfillment_value) -> void:
	var fulfillment_diffed = fulfillment_level - p_fulfillment_value
	if fulfillment_diffed < MIN_FULFILLMENT:
		fulfillment_level = MIN_FULFILLMENT
	else:
		fulfillment_level = fulfillment_diffed
