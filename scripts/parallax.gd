extends Parallax2D


@onready var camera: Camera2D = $"../Camera2D"
@onready var player_cam: Camera2D = $"../Control/SubViewportContainer/SubViewport/Main/Player/Camera2D"


func update_parallax() -> void:
	if player_cam:
		screen_offset = player_cam.get_screen_center_position() + camera.offset


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_parallax()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_parallax()
