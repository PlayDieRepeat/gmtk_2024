extends Node
class_name MaterialStack

var stacked_material: RMaterial
var stack_count: int

func _init(p_stacked_material: RMaterial, p_stack_count: int) -> void:
	stacked_material = p_stacked_material
	stack_count = p_stack_count

func add_to_stack(p_material_to_add: , p_count_to_add: int) -> int:
	assert(p_material_to_add.id == stacked_material.id, "Trying to add the incorrect material to a stack")
	
	stack_count += p_count_to_add

	return stack_count

# Removes a number of resources from stack, but will assert if not enough are availble
func remove_available_from_stack(p_material_to_remove: RMaterial, p_count_to_remove: int) -> int:
	assert(p_material_to_remove.id == stacked_material.id, "Trying to remove the incorrect material from a stack")
	assert(stack_count - p_count_to_remove >= 0, "Trying to remove more from stack than avaialbe, check if you shoukld use one of the alternate functions")
	
	stack_count -= p_count_to_remove

	return stack_count

# Removes a number from stack but will zero out if not enough are available
func remove_from_stack_to_zero(p_material_to_remove: RMaterial, p_count_to_remove: int) -> int:
	assert(p_material_to_remove.id == stacked_material.id, "Trying to remove the incorrect material from a stack")

	if stack_count - p_count_to_remove < 0:
		stack_count = 0
	else:
		stack_count -= p_count_to_remove

	return stack_count


# Removes a number from stack down to a negative value.  We probaly shouldnt use this most places
func remove_from_stack_to_negative(p_material_to_remove: RMaterial, p_count_to_remove: int) -> int:
	assert(p_material_to_remove.id == stacked_material.id, "Trying to remove the incorrect material from a stack")

	stack_count -= p_count_to_remove

	return stack_count