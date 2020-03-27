extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_height = 5
export var mouse_sens = 0.3
onready var head = $Head
onready var Camera = $Head/Camera

var velocity = Vector3()

var camera_x_rotation = 0
func _input(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().get_root().set_transparent_background(true)
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sens))
		var x_delta = event.relative.y * mouse_sens
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			Camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	var head_basis = head.get_global_transform().basis
	var direction = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z
	if Input.is_action_pressed("jump"):
		velocity.y += jump_height
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
	
	direction = direction.normalized()
	
	velocity.y -= gravity
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity)