extends Resource
class_name RTimeConstants

@export var seconds_in_hour: int = 12
@export var start_of_day: int = 6
@export var end_of_day: int = 21

func _init(p_seconds_in_hour: int = 0, p_start_of_day: int = 0, p_end_of_day: int = 0):
	seconds_in_hour = p_seconds_in_hour
	start_of_day = p_start_of_day
	end_of_day = p_end_of_day
