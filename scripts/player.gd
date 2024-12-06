extends CharacterBody2D
class_name Player

@export var player_color_rect: ColorRect

@export var speed = 130.0
@export var jump_velocity = -300.0

var player: MiniGameManager.PlayerData
var device_id: int = -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if device_id < 0:
		return


	# Handle jump.
	if Input.is_joy_button_pressed(device_id, JOY_BUTTON_A) and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
func construct(player: MiniGameManager.PlayerData):
	player_color_rect.color = player.color
	self.player = player
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed.unbind(2))
	
	
func _on_joy_connection_changed():
	if len(Input.get_connected_joypads()) >= player.number:
		device_id = Input.get_connected_joypads()[player.index]
