extends Node2D

var rng = RandomNumberGenerator.new()

# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
var is_shooting = false
var target = Vector2()
var type setget set_type

# Called when the node enters the scene tree for the first time.
func _ready():
#	$Rocket.add_to_group("enemies")
	rng.randomize()
	$NotShootingTimer.start()
	self.type = "enemy"
#	$Rocket.position.x = .5 * $Rocket.screen_size.x
#	$Rocket.position.y = -100
#	$Rocket.set_enemy()
	$Rocket.clamp_on = false
	$Rocket.position = Vector2(randi() % int($Rocket.screen_size.x - 100) + 50, -100)
	$Rocket.rotation = PI
#	$Rocket.set_speed(400, 4)
	$Rocket.health = 10
	$Rocket.max_health = 10

func _physics_process(delta):
	var rotation_direction = 0
	
	var velocity = target - $Rocket.position
	
	var point_to = float_mod(velocity.angle() + PI * 5/2, 2*PI)
	
	var current_direction = float_mod($Rocket.rotation, (2 * PI))
	
	current_direction = float_mod(current_direction + 2 * PI, (2 * PI))
	
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
	
	velocity = Vector2(rng.randfn(velocity.x, .2), rng.randfn(velocity.y, .2))
	$Rocket.set_input(velocity, rotation_direction)
	
	if is_shooting:
		if $Rocket.can_shoot:
			$Rocket.can_shoot = false
			for turret in $Rocket.current_turrets:
				var laser = Laser.instance()
				add_child(laser)
				laser.shoot("enemies", $Rocket.current_turrets[turret], $Rocket.position, $Rocket.rotation)

func set_start_position(x, y):
	$Rocket.position.x = x
	$Rocket.position.y = y

func set_target(position):
	target = position

func set_shooting_timers(shooting, not_shooting):
	$ShootingTimer.wait_time = shooting
	$NotShootingTimer.wait_time = not_shooting

func _on_ShootingTimer_timeout():
	is_shooting = false
	$NotShootingTimer.start()
	
func _on_NotShootingTimer_timeout():
	is_shooting = true
	$ShootingTimer.start()

func set_type(val):
	type = val
	if val.substr(val.length()-6) == "_enemy":
		val = val.substr(0, val.length() - 6)
	
	
	if val == "enemy" or val == "normal":
		$Rocket.type = "enemy"
	else:
		$Rocket.type = val + "_enemy"
	


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
