class_name SkyBox
extends ParallaxBackground

@export_group("Sky Layer")
@export var start_of_day_sky_alpha := 0.5
@export var mid_day_sky_alpha := 0.0
@export var end_of_day_sky_alpha := 0.8
@export var sky_alpha_layer_rect: TextureRect

@export_group("God Layer")
@export var god_starting_scalar := 1
@export var god_max_scalar := 2.0
@export var god_min_scalar := 0.7
@export var god_starting_alpha := 0.7
@export var god_min_alpha := 0.5
@export var god_max_alpha := 0.8
@export var god_layer_rect: TextureRect

var alpha := 0.0
var alpha_lerp_weight := 0.0
var alpha_lerp_target := 0.0

func _ready() -> void:
	assert(sky_alpha_layer_rect != null, "SkyBox is missing a reference to the alpha layer texture rect")
	assert(god_layer_rect != null, "SkyBox is missing a reference to the god layer texture rect")

# TODO we used change this to a cubic and create a set of skybox constants rather than rely on the time constants
func _on_time_of_day_changed(p_new_hour: int, _p_previous_hour: int, p_time_constants: RTimeConstants) -> void:
	if p_new_hour == p_time_constants.start_of_day:
		alpha = start_of_day_sky_alpha
	
	if p_new_hour < p_time_constants.mid_day:
		alpha_lerp_weight = (start_of_day_sky_alpha - mid_day_sky_alpha) / (p_time_constants.mid_day - p_time_constants.start_of_day)
		alpha_lerp_target = mid_day_sky_alpha
	elif p_new_hour > p_time_constants.mid_day:
		alpha_lerp_weight = (end_of_day_sky_alpha - mid_day_sky_alpha) / (p_time_constants.end_of_day - p_time_constants.mid_day)
		alpha_lerp_target = end_of_day_sky_alpha

func _process(delta: float) -> void:
		alpha = lerp(alpha, alpha_lerp_target, alpha_lerp_weight * delta)
		sky_alpha_layer_rect.self_modulate.a = alpha

func _on_set_god(p_god_data: RGod) -> void:
	if god_layer_rect.texture != p_god_data.image:
		god_layer_rect.texture = p_god_data.image
