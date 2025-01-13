extends MeshInstance3D

@export var default_heightmap: Image = null
var heightmap: Image = null
var mat: Material = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(default_heightmap != null)
	heightmap = default_heightmap.duplicate()

	mat = get_active_material(0)
	if mat is ShaderMaterial:
		var smat: ShaderMaterial = mat as ShaderMaterial
		smat.set_shader_parameter('heightmap', heightmap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		# move all points of the image up
		heightmap.flip_x()
		heightmap.flip_y()
