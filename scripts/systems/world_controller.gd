extends Node

@export var time_constant: RTimeConstants
var seconds_count: int = 0
var hour_count: int = 0
var day_count: int = 0
var starting_alpha_float: float = 0.5
var alpha_float: float = starting_alpha_float
var alpha_change_float: float = 0
var ui_time = null

signal new_day
signal new_hour

func _ready():
	var god = $ParallaxBackground/GodLayer/God
	god.texture = load("res://assets/images/gods/pig.png")
	hour_count = time_constant.start_of_day
	$ParallaxBackground/AlphaLayer/AlphaImage.self_modulate.a = alpha_float
	var margin_value: int = 15
	$CanvasLayer/MarginContainer.add_theme_constant_override("margin_left", margin_value)
	ui_time = $CanvasLayer/MarginContainer/Label
	alpha_change_float = alpha_float/(time_constant.seconds_in_hour*6)

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
		
	ui_time.text = "Time: " + hour_string + m_string

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
		new_hour.emit()
	
	if hour_count == time_constant.end_of_day:
		day_count += 1
		hour_count = time_constant.start_of_day
		new_day.emit()
