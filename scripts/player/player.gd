extends CharacterBody2D


const SPRINT_SPEED := 100.0
const WALK_SPEED := 50.0
const CROUCH_SPEED := 30.0

const SPRINT_JUMP_VEL := -200.0
const WALK_JUMP_VEL := -180.0
const CROUCH_JUMP_VEL := -150.0

@onready var main_cam: Camera2D = get_node("/root/Game/Camera2D")
@onready var fade: ColorRect = %Fade

var speed := WALK_SPEED
var jump_velocity := WALK_JUMP_VEL

var walking := false
var crouching := false
var height_ratio: float

var fading := false


func respawn():
	fading = true
	await fade.fade_to_black(0.25, 0.5, 1.0)

	main_cam.paused = true

	position = Vector2.ZERO
	velocity = Vector2.ZERO
	reset_physics_interpolation()

	var target: Vector2 = $Camera2D.get_screen_center_position()
	main_cam.update_offset(target)

	await get_tree().create_timer(0.4).timeout
	fade.unfade(0.8, 0.5, 0.6)
	await get_tree().create_timer(0.2).timeout
	fading = false


func _process(_delta: float) -> void:
	$AnimationTree.set("parameters/conditions/idle", is_on_floor and velocity.x == 0)
	$AnimationTree.set("parameters/conditions/walk_right", walking and is_on_floor and velocity.x != 0)


func _physics_process(delta: float) -> void:
	if not fading and position.y >= 256:
		respawn()
		return

	crouching = true if Input.is_action_pressed("crouch") else false
	if crouching:
		speed = CROUCH_SPEED
		jump_velocity = CROUCH_JUMP_VEL
		$CollisionShape2D.shape.size = Vector2(3.0, 16.0)
		$CollisionShape2D.position = Vector2(-0.5, 1.0)
	else:
		walking = true if Input.is_action_pressed("walk") else false
		if walking:
			speed = WALK_SPEED
			jump_velocity = WALK_JUMP_VEL
		else:
			speed = SPRINT_SPEED
			jump_velocity = SPRINT_JUMP_VEL

		$CollisionShape2D.shape.size = Vector2(3.0, 16.0)
		$CollisionShape2D.position = Vector2(-0.5, 1.0)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not fading:
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

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
