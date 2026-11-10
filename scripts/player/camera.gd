extends Camera2D


@onready var container: SubViewportContainer = $"../Control/SubViewportContainer"
@onready var sub_viewport: SubViewport = $"../Control/SubViewportContainer/SubViewport"
@onready var player_cam: Camera2D = $"../Control/SubViewportContainer/SubViewport/Main/Player/Camera2D"

@export var speed := 5.0
var smoothed: Vector2
var paused := true


func update_offset(target) -> void:
	if paused: smoothed = target
	offset = -((smoothed - target) * (container.size / Vector2(sub_viewport.size)))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var target: Vector2 = player_cam.get_screen_center_position()
	update_offset(target)
	paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target: Vector2 = player_cam.get_screen_center_position()
	smoothed = lerp(smoothed, target, speed * delta)
	update_offset(target)
