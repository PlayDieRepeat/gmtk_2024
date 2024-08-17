extends Camera2D

var threshold = 100
var step = 5
var maxStep = 5
var viewport_size = 0
func _ready() -> void:
	viewport_size = get_viewport_rect().size
	threshold = viewport_size.x/15

func _process(delta):
	var local_mouse_pos = get_local_mouse_position()
	if local_mouse_pos.x < threshold:
		step = clamp((threshold-local_mouse_pos.x)/10,1,5)
		position.x -= step
	elif local_mouse_pos.x > viewport_size.x - threshold:
		step = clamp((local_mouse_pos.x-(viewport_size.x - threshold))/10,1,5)
		position.x += step
