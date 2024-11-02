extends Resource
class_name RFavorRewards

@export var favor_material: RMaterial
@export var favor_low_reward_amt := 0
@export var favor_mid_reward_amt := 0
@export var favor_high_reward_amt := 0
@export var favor_awarded_cap := 0

func _init(p_favor_material: RMaterial = null, p_favor_low_reward_amt := 0,
			p_favor_mid_reward_amt := 0, p_favor_high_reward_amt := 0) -> void:
	favor_material = p_favor_material
	favor_low_reward_amt = p_favor_low_reward_amt
	favor_mid_reward_amt = p_favor_mid_reward_amt
	favor_high_reward_amt = p_favor_high_reward_amt
