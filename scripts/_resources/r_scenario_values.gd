extends Resource
class_name RScenarioValues

@export var starting_stone: RMaterialStack
@export var starting_wood: RMaterialStack
@export var starting_cloth: RMaterialStack
@export var starting_food: RMaterialStack
@export var starting_population: RMaterialStack
@export var starting_housing: RMaterialStack
@export var starting_hunger: RMaterialStack
@export var starting_fulfillment: RMaterialStack
@export var starting_favor: RMaterialStack

func _init(p_starting_stone = null, p_starting_wood = null, p_starting_cloth = null, p_starting_food = null,
p_starting_population = null, p_starting_fulfillment = null, p_starting_favor = null, p_starting_hunger = null,
p_starting_housing = null, ) -> void:
	starting_stone = p_starting_stone
	starting_wood = p_starting_wood
	starting_cloth = p_starting_cloth
	starting_food = p_starting_food
	starting_population = p_starting_population
	starting_fulfillment = p_starting_fulfillment
	starting_favor = p_starting_favor
	starting_hunger = p_starting_hunger
	starting_housing = p_starting_housing