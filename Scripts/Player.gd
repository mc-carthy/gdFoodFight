extends KinematicBody

const SPEED = 10
var motion = Vector3()


func _process(delta):
	move()


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
