extends CharacterBody2D

var record = []

#@onready var root = get_tree().current_scene

#var motion = Vector2(0, 0)

const SIDE_ACCEL = 140
const JUMP_POWER = 300
const GRAVITY = 10
const MAX_DOWN_VEL = 500
const JUMPPAD_POWER = 500
const WALL_JUMP_POWER = 500
const COYOTE_TIME = 0.015

var justWallJumped = false
var justJumped = false
var lastPosition

var gravityDirection = Vector2.DOWN

func _ready():
	lastPosition = position
	$player.play("appear")
	
	EventBus.addEventListener('invert_gravity', invert_gravity)
	EventBus.addEventListener('trampolin', trampolin)
	
func invert_gravity(args = {}):
	gravityDirection *= -1

func trampolin(args = {}):
	velocity *= -1

func _physics_process(delta):
	
	delta *= 60
	
	var objectRotation = 0
	rotation_degrees = rad_to_deg(gravityDirection.angle()) - 90
	up_direction = gravityDirection * -1
	
	$restartLabel.visible = getCrossAxis() == MAX_DOWN_VEL

	if Input.is_action_just_pressed('r'):
		match gravityDirection:
			Vector2.DOWN:
				gravityDirection = Vector2.LEFT
			Vector2.LEFT: 
				gravityDirection = Vector2.UP
			Vector2.UP:
				gravityDirection = Vector2.RIGHT
			Vector2.RIGHT: 
				gravityDirection = Vector2.DOWN
				
#		gravityDirection = gravityDirection.rotated(deg_to_rad(90))
#		die()
	
	if is_on_floor():
		$coyoteJump.stop()
		$coyoteJump.start(COYOTE_TIME)
	
	if Input.is_action_pressed("space"):
		
		if is_on_floor() or $coyoteJump.time_left > 0:
			$coyoteJump.stop()
#			velocity.y = -JUMP_POWER
			setCrossAxis(-JUMP_POWER)
			justJumped = false
#			SoundManager.play('jump')
	
	if Input.is_action_just_pressed("space") and not is_on_floor():
		if $RayCastLeft.is_colliding() or $RayCastRight.is_colliding():
#			velocity.y = -JUMP_POWER * 0.8
			setCrossAxis(-JUMP_POWER * 0.8)
			justWallJumped = true
			$holdMaxSpeed.start(0.225)

#			SoundManager.play('jump')
		
		if $RayCastLeft.is_colliding():
			setMainAxis(WALL_JUMP_POWER)
		if $RayCastRight.is_colliding():
			setMainAxis(-WALL_JUMP_POWER)
	
	if not justWallJumped:
		if Input.is_action_pressed("a"):
			addToMainAxis(-SIDE_ACCEL)
		elif Input.is_action_pressed("d"):
			addToMainAxis(SIDE_ACCEL)
	
	if not justWallJumped:
#		velocity.x = lerp(velocity.x, 0.0, 0.3)
		setMainAxis(lerpf(getMainAxis(), 0.0, 0.3))
		
	
#	velocity += GRAVITY * delta
	addToCrossAxis(GRAVITY * delta)
	
	if MAX_DOWN_VEL < getCrossAxis():
		setCrossAxis(MAX_DOWN_VEL)
	
	move_and_slide()


func jumppad(args):
	print('JUMPAD')
	pass

func die():
	position = lastPosition
	velocity = Vector2.ZERO
	gravityDirection = Vector2.DOWN
	$player.play("appear")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4:
			$Camera2D.zoom += Vector2(0.1, 0.1)
		elif event.button_index == 5:
			$Camera2D.zoom -= Vector2(0.1, 0.1)
		
		$Camera2D.zoom.x = clampf($Camera2D.zoom.x, 0.5, 3)
		$Camera2D.zoom.y = clampf($Camera2D.zoom.y, 0.5, 3)

func _on_holdMaxSpeed_timeout():
	justWallJumped = false

# Axis Functions, used for Rotation
# Main Axis = Side to Side Movement
func getMainAxis():
	if gravityDirection == Vector2.DOWN:
		return velocity.x
	elif gravityDirection == Vector2.UP:
		return -velocity.x
	elif gravityDirection == Vector2.LEFT:
		return velocity.y
	elif gravityDirection == Vector2.RIGHT:
		return -velocity.y

func setMainAxis(number: float):
	if gravityDirection == Vector2.DOWN:
		velocity.x = number
	elif gravityDirection == Vector2.UP:
		velocity.x = -number
	elif gravityDirection == Vector2.LEFT:
		velocity.y = number
	elif gravityDirection == Vector2.RIGHT:
		velocity.y = -number

func addToMainAxis(number: float):
	setMainAxis(getMainAxis() + number)


func getCrossAxis():
	if gravityDirection == Vector2.DOWN:
		return velocity.y
	elif gravityDirection == Vector2.UP:
		return -velocity.y
	elif gravityDirection == Vector2.LEFT:
		return -velocity.x
	elif gravityDirection == Vector2.RIGHT:
		return velocity.x
	
func setCrossAxis(number: float):
	if gravityDirection == Vector2.DOWN:
		velocity.y = number
	elif gravityDirection == Vector2.UP:
		velocity.y = -number
	elif gravityDirection == Vector2.LEFT:
		velocity.x = -number
	elif gravityDirection == Vector2.RIGHT:
		velocity.x = number

func addToCrossAxis(number: float):
	setCrossAxis(getCrossAxis() + number)
