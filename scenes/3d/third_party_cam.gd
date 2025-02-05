extends Node3D

@export_group("Camera Properties")
@export_range(0.2, 1.0) var mouse_sensitivity := 0.4
@export_range(-0.90, 0.0, 5.0) var top_clamp_deg := -30.0
@export_range(0.0, 90.0, 5.0) var bottom_clamp_deg := 60.0
@export_range(0.0, 90.0, 5.0) var side_clamp_deg := 45.0

### class properties ###
@onready var _camera : Node3D = $SpringArm3D/Camera3D
var _mouse_direction := Vector2.ZERO
var top_clamp := deg_to_rad(top_clamp_deg)
var bottom_clamp := deg_to_rad(bottom_clamp_deg)
var side_clamp := deg_to_rad(side_clamp_deg)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(_camera != null)

func _unhandled_input(event: InputEvent) -> void:
	var is_mouse_motion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if is_mouse_motion:
		_mouse_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	rotation.x -= _mouse_direction.y * delta
	rotation.x = clamp(rotation.x, top_clamp, bottom_clamp)
	rotation.y -= _mouse_direction.x * delta
	rotation.y = clamp(rotation.y, -side_clamp, side_clamp)
	_mouse_direction = Vector2.ZERO
