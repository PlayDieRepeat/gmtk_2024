extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
		var refreshRate := DisplayServer.screen_get_refresh_rate()
		Engine.max_fps = int(refreshRate) if refreshRate > 0.0 else 60

	if Engine.has_singleton("ImGuiAPI"):
		var io: Object = ImGui.GetIO()
		io.ConfigFlags |= ImGui.ConfigFlags_ViewportsEnable
		io.ConfigFlags |= ImGui.ConfigFlags_DockingEnable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	ImGui.Begin("Hungry Debug", [], ImGui.WindowFlags_AlwaysAutoResize)
	ImGui.End()
	pass