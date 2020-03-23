extends "res://Scripts/Character.gd"

# Movement constants
const MAX_SPEED = 20
const GRAVITY = -45
const JUMP_SPEED = 15
const ACC = 5
const DEC = 15

# Momvement variables
var vel = Vector3()
var dir = Vector3()


# Animation constants
const BLEND_MINIMUM = 0.25
const RUN_BLEND_AMOUNT = 0.1
const IDLE_BLEND_AMOUNT = 0.25

# Animation variables
var move_state = 0 # 0 - Idle, 1 - run
var facing_direction = 0

func _process(delta):
	move(delta)
	face_forward()
	animate()

func face_forward():
	$Armature.rotation.y = facing_direction


func move(delta):
	var movement_dir = get_2d_movement()
	var camera_xform = $Camera.get_global_transform()
	
	dir = Vector3(0, 0, 0)
	
	dir += camera_xform.basis.z.normalized() * movement_dir.y
	dir += camera_xform.basis.x.normalized() * movement_dir.x
	
	dir = move_vertically(dir, delta)
	vel = h_acc(dir, delta)
	
	move_and_slide(vel, Vector3.UP)

func get_2d_movement():
	var dx = 0
	var dy = 0
	
	if Input.is_action_pressed('forward'):
		dy -= 1
	if Input.is_action_pressed('backward'):
		dy += 1
	if Input.is_action_pressed('right'):
		dx += 1
	if Input.is_action_pressed('left'):
		dx -= 1
	
	return Vector2(dx, dy).normalized()

func move_vertically(dir, delta):
	vel.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = JUMP_SPEED
	elif is_on_floor():
		vel.y = 0
	
	dir.y = 0
	dir = dir.normalized()
	
	return dir

func h_acc(dir, delta):
	var vel2d = vel
	vel2d.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel = 0
	if dir.dot(vel2d) > 0:
		accel = ACC
	else:
		accel = DEC
	
	vel2d = vel2d.linear_interpolate(target, accel * delta)
	
	vel.x = vel2d.x
	vel.z = vel2d.z
	
	return vel

func animate():
	var animate = $Armature/AnimationTreePlayer
	
	if vel.length() > BLEND_MINIMUM:
		move_state += RUN_BLEND_AMOUNT
	else:
		move_state -= IDLE_BLEND_AMOUNT
	
	move_state = clamp(move_state, 0, 1)
	animate.blend2_node_set_amount("Move", move_state)

func _input(event):
	if Input.is_action_just_pressed("fire"):
		fire()
