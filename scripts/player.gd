extends CharacterBody2D
class_name Player


@export var player_color_rect: ColorRect

@export var walk_speed = 130.0
@export var dash_speed = 300.0
@export var dash_duration = 1.5
@export var dash_cooldown = 1.0
@export var jump_velocity = -300.0

var speed: float = 0
var enabled: bool = true
var player: MiniGameManager.PlayerData
var device_id: int = -1
var can_dash: bool = true
var is_dash_pressed: bool = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if device_id < 0 or not enabled:
		velocity.x = 0
		move_and_slide()
		return


	# Handle jump.
	if Input.is_joy_button_pressed(device_id, JOY_BUTTON_A) and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_joy_button_pressed(device_id, JOY_BUTTON_RIGHT_SHOULDER):
		if not is_dash_pressed:
			is_dash_pressed = true
			dash()
	else:
		is_dash_pressed = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func dash():
	if not can_dash:
		return
	can_dash = false
	speed = dash_speed
	await get_tree().create_timer(dash_duration).timeout
	speed = walk_speed
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true


func construct(player: MiniGameManager.PlayerData):
	speed = walk_speed
	
	player_color_rect.color = player.color
	self.player = player
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed.unbind(2))
	_on_joy_connection_changed()
	
	
func _on_joy_connection_changed():
	if len(Input.get_connected_joypads()) >= player.number:
		device_id = Input.get_connected_joypads()[player.index]
