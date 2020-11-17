extends Node2D

var rng = RandomNumberGenerator.new()

# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
var is_shooting = false
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Rocket.add_to_group("enemies")
	rng.randomize()
	$IsShootingTimer.start()
#	$Rocket.position.x = .5 * $Rocket.screen_size.x
#	$Rocket.position.y = -100
	$Rocket.set_enemy()
	$Rocket.clamp_on = false
	$Rocket.position = Vector2(randi() % int($Rocket.screen_size.x - 100) + 50, -100)
	$Rocket.rotation = PI
	$Rocket.set_speed(300, 3)
	$Rocket.health = 10

func _physics_process(delta):
	var rotation_direction = 0
	
	var velocity = target - $Rocket.position
	
	var point_to = float_mod(velocity.angle() + PI * 5/2, 2*PI)
	
	var current_direction = float_mod($Rocket.rotation, (2 * PI))
	
#	print("_")
#	print(point_to)
#	print(current_direction)
#	current_direction = abs(current_direction)
	current_direction = float_mod(current_direction + 2 * PI, (2 * PI))
#	print(current_direction)
	
	if float_eq(point_to, current_direction):
		rotation_direction = 0
	else:
		if point_to < PI:
#			print('first')
			if current_direction > point_to and current_direction < point_to + PI:
				rotation_direction = -1
			else:
				rotation_direction = 1
		else:
#			print('second')
			if current_direction < point_to and current_direction > point_to - PI:
				rotation_direction = 1
			else:
				rotation_direction = -1
	
	
	
	if velocity.length() < 150:
		velocity = Vector2()
	
#	rotation_direction = rng.randfn(rotation_direction, .5)
#	print(rotation_direction)
	$Rocket.set_input(velocity, rotation_direction)
	
	if is_shooting:
		if $Rocket.can_shoot:
			$Rocket.can_shoot = false
			var laser = Laser.instance()
			add_child(laser)
			laser.shoot("enemies", $Rocket.position, $Rocket.rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_start_position(x, y):
	$Rocket.position.x = x
	$Rocket.position.y = y

func set_target(position):
	target = position

func _on_IsShootingTimer_timeout():
	is_shooting = not is_shooting

func float_eq(a, b):
	var epsilon = .1
	return abs(a - b) < epsilon

func float_mod(a, b):
	# Handling negative values 
	var neg = 1
	if a < 0: 
		a = -a 
		neg = -1
	if b < 0: 
		b = -b 
  
	# Finding mod by repeated subtraction 
	var mod = a 
	while mod >= b: 
		mod = mod - b 
  
	# Sign of result typically  
	# depends on sign of a. 
	if a < 0: 
		return -mod 
  
	return mod * neg
