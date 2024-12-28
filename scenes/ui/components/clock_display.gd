extends Container
class_name ClockDisplay

const AM := "AM"
const PM := "PM"

@export var clock_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(clock_label != null, "No clock label referenced in clock display.")

func _on_time_of_day_changed(p_new_hour: int, _p_previous_hour: int, p_time_constants: RTimeConstants) -> void:
	var time_text: String
	
	if p_new_hour % p_time_constants.mid_day == 0:
		time_text = str(p_time_constants.mid_day)
	else:
		time_text = str(p_new_hour % p_time_constants.mid_day)
	
	if p_new_hour < p_time_constants.mid_day:
		time_text = time_text + " " + AM
	else:
		time_text = time_text + " " + PM
		
	clock_label.text = time_text
