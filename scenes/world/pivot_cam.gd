extends Node3D

var velocity := Vector2.ZERO
var camera : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = $SpringArm3D/Camera3D
	camera.position.y += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("down"):
		velocity.y += 1
	if Input.is_action_just_pressed("right"):
		velocity.x += 1
	if Input.is_action_just_pressed("left"):
		velocity.x -= 1
	
	position = Vector3(velocity.x, 1, velocity.y)
	camera.transform = camera.transform.looking_at(self.position)		
