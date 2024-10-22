extends Resource
class_name RTimeConstants

@export var seconds_in_hour := 12
@export var start_of_day := 6
@export var end_of_day := 21
@export var mid_day := 12

func _init(p_seconds_in_hour := 0, p_start_of_day := 0, p_end_of_day := 0, p_mid_day := 0):
	seconds_in_hour = p_seconds_in_hour
	start_of_day = p_start_of_day
	end_of_day = p_end_of_day
	mid_day = p_mid_day
