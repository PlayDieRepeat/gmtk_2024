extends CharacterBody3D

@export_group("Agent Properties")
# How fast the player moves in meters per second.
@export var speed := 15.0
@export var rotate_speed := 15.0
@export var acceleration := 32.0
@onready var _camera : Node3D = $Pivot
var _last_movement_direction := Vector3.BACK

func _physics_process(delta: float) -> void:
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
	var y_velocity := velocity.y
	velocity.y = 0.0
	# Moving the character
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	
	move_and_slide()
	
	if direction.length() > 0.2:
		_last_movement_direction = direction
	#turn the agent
	#var target_angle := Vector3.FORWARD.signed_angle_to(_last_movement_direction, Vector3.UP)
	#_mesh.global_rotation.y = lerp_angle(_mesh.rotation.y, target_angle, rotate_speed * delta)
