extends CharacterBody2D

var record = []

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

@onready var root = Helpers.getSceneRoot()

var was_just_in_air = false

func _ready():
	lastPosition = position
	$player.play("appear")

	EventBus.addEventListener('trampolin', trampolin)
	EventBus.addEventListener('checkpoint', checkpoint)
	EventBus.addEventListener('die', die)
	EventBus.addEventListener('jumppad', jumppad)

func trampolin(_args = {}):
	velocity *= -1

func checkpoint(_args = {}):
	lastPosition = position

func _physics_process(delta):
	$"Sprite/PointLight2D".visible = root.isDark

	delta *= 60

	rotation_degrees = rad_to_deg(root.gravityDirection.angle()) - 90
	up_direction = root.gravityDirection * -1

	$"Sprite/restartLabel".visible = getCrossAxis() == MAX_DOWN_VEL and not root.isFinished

	if root.isShellVisible:
		return

	if Input.is_action_just_pressed('r') and not root.isFinished:
		EventBus.emitEvent('die')

	if is_on_floor():
		$coyoteJump.stop()
		$coyoteJump.start(COYOTE_TIME)

		if was_just_in_air:
			$ground_punch_particles.emitting = true

		was_just_in_air = false

	if not is_on_floor():
		was_just_in_air = true

	if Input.is_action_pressed("space") and not root.isFinished:
		if is_on_floor() or $coyoteJump.time_left > 0:
			$coyoteJump.stop()
			setCrossAxis(-JUMP_POWER)
			justJumped = false
#			SoundManager.play('jump')

	if Input.is_action_just_pressed("space") and not is_on_floor():
		if $RayCastLeft.is_colliding() or $RayCastRight.is_colliding():
			setCrossAxis(-JUMP_POWER * 0.8)
			justWallJumped = true
			$holdMaxSpeed.start(0.225)
#			SoundManager.play('jump')

		if $RayCastLeft.is_colliding():
			setMainAxis(WALL_JUMP_POWER)
		if $RayCastRight.is_colliding():
			setMainAxis(-WALL_JUMP_POWER)

	if not justWallJumped and not root.isFinished:
		if Input.is_action_pressed("a"):
			addToMainAxis(-SIDE_ACCEL)
		elif Input.is_action_pressed("d"):
			addToMainAxis(SIDE_ACCEL)

	if not justWallJumped:
		setMainAxis(lerpf(getMainAxis(), 0.0, 0.3))

	addToCrossAxis(GRAVITY * delta)

	if MAX_DOWN_VEL < getCrossAxis():
		setCrossAxis(MAX_DOWN_VEL)

	move_and_slide()


func jumppad(_args):
	setCrossAxis(-JUMPPAD_POWER)
	pass

func die(_args = {}):
	position = lastPosition
	velocity = Vector2.ZERO
	$player.play("appear")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4:
			$Camera2D.zoom += Vector2(0.1, 0.1)
		elif event.button_index == 5:
			$Camera2D.zoom -= Vector2(0.1, 0.1)

		const MAX_ZOOM = 5
		const MIN_ZOOM = 0.5

		$Camera2D.zoom.x = clampf($Camera2D.zoom.x, MIN_ZOOM, MAX_ZOOM)
		$Camera2D.zoom.y = clampf($Camera2D.zoom.y, MIN_ZOOM, MAX_ZOOM)

func _on_holdMaxSpeed_timeout():
	justWallJumped = false

# Axis Functions, used for Rotation
# Main Axis = Side to Side Movement
func getMainAxis():
	if root.gravityDirection == Vector2.DOWN:
		return velocity.x
	elif root.gravityDirection == Vector2.UP:
		return -velocity.x
	elif root.gravityDirection == Vector2.LEFT:
		return velocity.y
	elif root.gravityDirection == Vector2.RIGHT:
		return -velocity.y

func setMainAxis(number: float):
	if root.gravityDirection == Vector2.DOWN:
		velocity.x = number
	elif root.gravityDirection == Vector2.UP:
		velocity.x = -number
	elif root.gravityDirection == Vector2.LEFT:
		velocity.y = number
	elif root.gravityDirection == Vector2.RIGHT:
		velocity.y = -number

func addToMainAxis(number: float):
	setMainAxis(getMainAxis() + number)


func getCrossAxis():
	if root.gravityDirection == Vector2.DOWN:
		return velocity.y
	elif root.gravityDirection == Vector2.UP:
		return -velocity.y
	elif root.gravityDirection == Vector2.LEFT:
		return -velocity.x
	elif root.gravityDirection == Vector2.RIGHT:
		return velocity.x

func setCrossAxis(number: float):
	if root.gravityDirection == Vector2.DOWN:
		velocity.y = number
	elif root.gravityDirection == Vector2.UP:
		velocity.y = -number
	elif root.gravityDirection == Vector2.LEFT:
		velocity.x = -number
	elif root.gravityDirection == Vector2.RIGHT:
		velocity.x = number

func addToCrossAxis(number: float):
	setCrossAxis(getCrossAxis() + number)
