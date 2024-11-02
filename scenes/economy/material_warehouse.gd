extends Node
class_name MaterialWarehouse

@export var starting_values: RScenarioValues
var can_check_stock := false
signal material_stack_changed(p_material: RMaterial, p_new_value: int, p_old_value: int)
signal initialize_stack_ui(p_stacks: Array[MaterialStack])

var material_stacks: Array[MaterialStack] = []

func _ready() -> void:
	material_stacks.append(MaterialStack.new(starting_values.starting_stone.stacked_material, starting_values.starting_stone.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_wood.stacked_material, starting_values.starting_wood.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_cloth.stacked_material, starting_values.starting_cloth.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_food.stacked_material, starting_values.starting_food.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_housing.stacked_material, starting_values.starting_housing.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_population.stacked_material, starting_values.starting_population.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_fulfillment.stacked_material, starting_values.starting_fulfillment.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_hunger.stacked_material, starting_values.starting_hunger.stack_count))
	material_stacks.append(MaterialStack.new(starting_values.starting_favor.stacked_material, starting_values.starting_favor.stack_count))
	initialize_stack_ui.emit(material_stacks)

	can_check_stock = true

func _process(_delta: float) -> void:
	if ImGui.Begin("Hungry Debug"):
		if ImGui.BeginTabBar("Menus"):
			if ImGui.BeginTabItem("Materials"):
				ImGui.SeparatorText("Material Stacks")
				ImGui.PushItemWidth(200)
				for stack in material_stacks:
					var count: Array[int] = [stack.stack_count]
					if ImGui.InputInt("%s" % stack.stacked_material.display_name, count) and count[0] >= 0:
						_set_stack_count(stack, count[0])
				ImGui.PopItemWidth()
				ImGui.EndTabItem()
			ImGui.EndTabBar()
		ImGui.End()

func try_get_materials(p_materials_to_check: Array[RMaterialStack]) -> bool:
	var result = false
	if can_check_stock == true:
		can_check_stock = false
		var all_materials_available = true
		for material_stack in p_materials_to_check:
			if all_materials_available == true:
				var stack = get_stack_from_material(material_stack.stacked_material)
				if stack.get_stack_count(material_stack.stacked_material) - material_stack.stack_count < 0:
					all_materials_available = false
		if all_materials_available == true:
			for material_stack in p_materials_to_check:
				remove_material(material_stack.stacked_material, material_stack.stack_count)
			result = true
		else:
			result = false
	else:
		result = false
	can_check_stock = true
	return result

func check_material_stock(p_material_to_find: RMaterial) -> int:
	var result := -1
	if can_check_stock == true:
		var stack = get_stack_from_material(p_material_to_find)
		result = stack.get_stack_count(p_material_to_find)
	return result

func get_stack_from_material(p_material_to_find: RMaterial) -> MaterialStack:
	var result = null
	for stack in material_stacks:
		if stack.stacked_material == p_material_to_find:
			result = stack
	return result

func add_material(p_material_to_add: RMaterial, p_amount: int) -> void:
	var stack = get_stack_from_material(p_material_to_add)

	assert(stack != null, "A stack of this material doesnt exist")
	
	_add_to_stack(stack, p_amount)

func remove_material(p_material_to_remove: RMaterial, p_amount: int) -> void:
	var stack = get_stack_from_material(p_material_to_remove)

	assert(stack != null, "A stack of this material doesnt exist")
	
	_remove_from_stack(stack, p_amount)

func _add_to_stack(p_material_stack: MaterialStack, p_amount_to_add: int) -> void:
	var material = p_material_stack.stacked_material
	var old_value = p_material_stack.get_stack_count(p_material_stack.stacked_material)
	var new_value = p_material_stack.add_to_stack(p_material_stack.stacked_material, p_amount_to_add)

	material_stack_changed.emit(material, new_value, old_value)

func _remove_from_stack(p_material_stack: MaterialStack, p_amount_to_remove: int) -> void:
	var material = p_material_stack.stacked_material
	var old_value = p_material_stack.get_stack_count(p_material_stack.stacked_material)
	var new_value = p_material_stack.remove_from_stack_to_zero(p_material_stack.stacked_material, p_amount_to_remove)

	material_stack_changed.emit(material, new_value, old_value)

func _set_stack_count(p_material_stack: MaterialStack, p_count: int) -> void:
	var material = p_material_stack.stacked_material
	var old_value = p_material_stack.get_stack_count(p_material_stack.stacked_material)
	var new_value = p_material_stack.set_stack_count(p_material_stack.stacked_material, p_count)

	material_stack_changed.emit(material, new_value, old_value)
