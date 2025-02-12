extends CharacterBody3D

class_name ThirdPersonCharacter

@export_group("Agent Properties")
# How fast the player moves in meters per second.
@export var speed := 15.0
@export var rotate_speed := 15.0
@export var acceleration := 32.0
@export_group("Camera Properties")
@export_range(0.2, 1.0) var mouse_sensitivity := 0.4
@export_range(0.0, 90.0, 5.0) var top_clamp_deg := 60.0
@export_range(0.0, 90.0, 5.0) var bottom_clamp_deg := 30.0
@export_range(0.0, 90.0, 5.0) var side_clamp_deg := 45.0
## PROPERTIES
@onready var _camera : Camera3D = %MainCamera
var _last_movement_direction := Vector3.BACK
var mouse_world_coords := Vector3.ZERO
var _mouse_direction := Vector2.ZERO
var top_clamp := deg_to_rad(-top_clamp_deg)
var bottom_clamp := deg_to_rad(bottom_clamp_deg)
var side_clamp := deg_to_rad(side_clamp_deg)
var is_y_inverted := false
var is_x_inverted := false

func _ready() -> void:
	assert(_camera != null)

func get_camera() -> Camera3D:
	return _camera

func get_clicked_camera_position(p_mouse_position : Vector2) -> Vector3:
	return _camera.project_ray_origin(p_mouse_position)

func _physics_process(delta: float) -> void:
	rotation.x -= _mouse_direction.y * delta
	rotation.x = clamp(rotation.x, top_clamp, bottom_clamp)
	rotation.y -= _mouse_direction.x * delta
	rotation.y = clamp(rotation.y, -side_clamp, side_clamp)
	_mouse_direction = Vector2.ZERO

	# We create a local variable to store the input direction
	var direction:= Vector3.ZERO
	var input_vector := Input.get_vector("left", "right", "up", "down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	direction = forward * input_vector.y + right * input_vector.x
	direction.y = 0.0
	
	# normalize for diagonal directions
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node
		#transform.basis = Basis.looking_at(direction)
	
	# Vertical velocity
	velocity.y = 0.0
	# Moving the character
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	
	move_and_slide()
	
	if direction.length() > 0.2:
		_last_movement_direction = direction
	#turn the agent
	#var target_angle := Vector3.FORWARD.signed_angle_to(_last_movement_direction, Vector3.UP)
	#_mesh.global_rotation.y = lerp_angle(_mesh.rotation.y, target_angle, rotate_speed * delta)

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_mouse_direction = event.screen_relative * mouse_sensitivity
			if is_y_inverted:
				_mouse_direction.y = -_mouse_direction.y
			if is_x_inverted:
				_mouse_direction.x = -_mouse_direction.x
	else:
		if event is InputEventMouseButton:
			if event.button_index == 1 and event.pressed == true:
				print("Event mouse position: ", event.position)
				#turn screen coords into world coords
				mouse_world_coords = _camera.project_ray_origin(event.position)
				print(mouse_world_coords)
