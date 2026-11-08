extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0

@onready var main_cam: Camera2D = get_node("/root/Game/Camera2D")
@onready var fade: ColorRect = get_node("../CanvasLayer/ColorRect")

var height_ratio: float
var fading := false


func _physics_process(delta: float) -> void:
	if not fading and position.y >= 128:
		fading = true
		await fade.fade_to_black(0.25, 0.5, 1.0)
		
		main_cam.paused = true
		
		position = Vector2.ZERO
		velocity = Vector2.ZERO
		reset_physics_interpolation()
		
		var target: Vector2 = $Camera2D.get_screen_center_position()
		main_cam.update_offset(target)
		
		await get_tree().create_timer(0.4).timeout
		fade.unfade(0.6, 0.5, 0.6)
		fading = false

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	$ShadowRay.force_raycast_update()
	if $ShadowRay.is_colliding():
		$Shadow.global_position.y = $ShadowRay.get_collision_point().y
		height_ratio = 0.5 - $Shadow.position.y / $ShadowRay.target_position.y
	else:
		height_ratio = 0.0

	$Shadow.modulate.a = height_ratio

	var shadow_scale: float = 0.5 + height_ratio
	$Shadow.scale = Vector2(shadow_scale, shadow_scale)
	
	$Shadow.position.y += 1
