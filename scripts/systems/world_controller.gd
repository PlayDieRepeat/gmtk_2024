extends Node

@export var time_constant: RTimeConstants
var seconds_count: int = 0
var hour_count: int = 0
var day_count: int = 0
var starting_alpha_float: float = 0.5
var alpha_float: float = starting_alpha_float
var alpha_change_float: float = 0
var ui_time: Label = null
var ui_tithing: Label = null
var ui_favor: Label = null
var ui_time_text_ph: String = "Time: %s%s"
var ui_tithing_text_ph: String = "Tithing: %s"
var ui_favor_text_ph: String = "Favor: %d"
var cloth_mat_cache: RMaterial
var favor_mat_cache: RMaterial
var food_mat_cache: RMaterial
var fulfillment_mat_cache: RMaterial
var housing_mat_cache: RMaterial
var hunger_mat_cache: RMaterial
var stone_mat_cache: RMaterial
var villager_mat_cache: RMaterial
var wood_mat_cache: RMaterial

signal new_day
signal new_hour

func _ready():
	_load_all_resources()
	ui_time = $CanvasLayer/MarginContainer/VBoxContainer/Time
	ui_tithing = $CanvasLayer/MarginContainer/VBoxContainer/Tithing
	ui_tithing.text = "Tithing: "
	ui_favor = $CanvasLayer/MarginContainer/VBoxContainer/Favor
	ui_favor.text = "Favor: "
	var god_background: TextureRect = $ParallaxBackground/GodLayer/GodImage
	var new_god: RGod = ResourceLoader.load("res://resources/gods/cat_god.tres", "RGod")
	%God.set_god(new_god)
	god_background.texture = %God.god_data.image
	hour_count = time_constant.start_of_day
	$ParallaxBackground/AlphaLayer/AlphaImage.self_modulate.a = alpha_float
	var margin_value: int = 15
	$CanvasLayer/MarginContainer.add_theme_constant_override("margin_left", margin_value)
	alpha_change_float = alpha_float/(time_constant.seconds_in_hour*6)

func _load_all_resources() -> void:
	cloth_mat_cache = ResourceLoader.load("res://resources/materials/cloth.tres")
	favor_mat_cache = ResourceLoader.load("res://resources/materials/favor.tres")
	food_mat_cache = ResourceLoader.load("res://resources/materials/food.tres")
	fulfillment_mat_cache = ResourceLoader.load("res://resources/materials/fulfillment.tres")
	housing_mat_cache = ResourceLoader.load("res://resources/materials/housing.tres")
	hunger_mat_cache = ResourceLoader.load("res://resources/materials/hunger.tres")
	stone_mat_cache = ResourceLoader.load("res://resources/materials/stone.tres")
	villager_mat_cache = ResourceLoader.load("res://resources/materials/villager.tres")
	wood_mat_cache = ResourceLoader.load("res://resources/materials/wood.tres")

func _process(_delta: float) -> void:
	var m_string: String = " AM"
	var hour_string: String = str(hour_count)
	
	if hour_count % 12 == 0:
		hour_string = "12"
	else:
		hour_string = str(hour_count % 12)
	
	if hour_count < 12:
		m_string = " AM"
	else:
		m_string = " PM"
		
	#ui_time.text = "Time: " + hour_string + m_string
	ui_time.text = ui_time_text_ph % [hour_string,m_string]

func _on_global_timer_timeout():
	seconds_count += 1
	
	if hour_count < 12:
		if hour_count == 6 and alpha_float > starting_alpha_float:
			alpha_float = starting_alpha_float
		alpha_float = alpha_float - alpha_change_float
	elif hour_count > 12:
		alpha_float = alpha_float + alpha_change_float
	else:
		alpha_float = 0
	$ParallaxBackground/AlphaLayer/AlphaImage.self_modulate.a = alpha_float
	
	if seconds_count == time_constant.seconds_in_hour:
		hour_count += 1
		seconds_count = 0
		var random_tithe: int = randi_range(8, 12)
		var tithing: RMaterialStack = RMaterialStack.new(villager_mat_cache, random_tithe)
		ui_tithing.text = ui_tithing_text_ph % tithing.stacked_material.display_name
		%God.tithe(tithing)
		new_hour.emit()
	
	if hour_count == time_constant.end_of_day:
		day_count += 1
		hour_count = time_constant.start_of_day
		new_day.emit()


func _on_god_favor_has_changed(p_favor: int) -> void:
	ui_favor.text = ui_favor_text_ph % p_favor
