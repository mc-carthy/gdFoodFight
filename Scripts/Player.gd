extends KinematicBody

const SPEED = 10
var motion = Vector3()

# Animation constants
const BLEND_MINIMUM = 0.125
const RUN_BLEND_AMOUNT = 0.1

# Animation variables
var move_state = 0 # 0 - Idle, 1 - run

func _process(delta):
	move()
	face_forward()
	animate()

func move():
	var dx = 0
	var dz = 0
	
	if Input.is_action_pressed('forward'):
		dz -= 1
	if Input.is_action_pressed('backward'):
		dz += 1
	if Input.is_action_pressed('right'):
		dx += 1
	if Input.is_action_pressed('left'):
		dx -= 1
	

	
	motion = Vector3(dx, 0, dz) * SPEED
	move_and_slide(motion, Vector3.UP)

func face_forward():
	pass

func animate():
	var animate = $Armature/AnimationTreePlayer
	
	if motion.length() > BLEND_MINIMUM:
		move_state += RUN_BLEND_AMOUNT
	else:
		move_state -= RUN_BLEND_AMOUNT
	
	move_state = clamp(move_state, 0, 1)
	animate.blend2_node_set_amount("Move", move_state)
