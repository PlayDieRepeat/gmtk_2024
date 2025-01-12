extends MeshInstance3D

@export var default_heightmap: Image = null
var heightmap: ImageTexture = null

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(default_heightmap != null)
	heightmap.create_from_image(default_heightmap)
	self.mesh.material.shader.set_default_texture_parameter("heightmap", heightmap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up"):
		# move all points of the image up
		pass
