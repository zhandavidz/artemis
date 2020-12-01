extends Node2D


# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
var allow_shooting = false
var can_move = false
var HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	$Rocket.type = "player"
	HUD = get_node("/root/Main/AsteroidMain/HUD")
	
	$Rocket.position.x = .5 * $Rocket.screen_size.x
	$Rocket.position.y = .7 * $Rocket.screen_size.y

func set_pregame():
	allow_shooting = false
	can_move = false
	$Rocket.position.x = .5 * $Rocket.screen_size.x
	$Rocket.position.y = .5 * $Rocket.screen_size.y

func start_game():
	allow_shooting = true
	can_move = true
	$Rocket.position.x = .5 * $Rocket.screen_size.x
	$Rocket.position.y = .7 * $Rocket.screen_size.y

func _physics_process(delta):
	var velocity = Vector2()
	var rotation_direction = 0
	if can_move:
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("right"):
			velocity.x += 1
#	velocity = velocity.normalized()
	
#	rotation_direction = get_keyboard_rotation()
	rotation_direction = get_mouse_rotation_speed_limited(velocity)

	
#	$Rocket.set_input(velocity.rotated($Rocket.rotation), rotation_direction)
	$Rocket.set_input(velocity, rotation_direction)
	set_rocket_direction()
	
	if allow_shooting and Input.is_action_pressed("shoot"):
		if $Rocket.can_shoot:
			$Rocket.can_shoot = false
			for turret in $Rocket.current_turrets:
				var laser = Laser.instance()
				add_child(laser)
				laser.shoot("players", $Rocket.current_turrets[turret], $Rocket.position, $Rocket.rotation)
	
#	HUD.change_metal_count(1)
	if get_parent().is_on_ingot($Rocket.position):
		HUD.change_metal_count(1)
	

func get_keyboard_rotation():
	var rotation_direction = 0
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	return rotation_direction

func get_mouse_rotation_speed_limited(velocity):
	var rotation_direction = 0
	
#	var velocity = target - $Rocket.position
	
	
#	var point_to = float_mod(velocity.angle() + PI * 5/2, 2*PI)
	var point_to = float_mod((get_viewport().get_mouse_position() - $Rocket.position).angle() + PI * 5/2, 2*PI)
	
	var current_direction = float_mod($Rocket.rotation, (2 * PI))
	
	current_direction = float_mod(current_direction + 2 * PI, (2 * PI))
	
	if float_eq(point_to, current_direction):
		rotation_direction = 0
	else:
		if point_to < PI:
			if current_direction > point_to and current_direction < point_to + PI:
				rotation_direction = -1
			else:
				rotation_direction = 1
		else:
			if current_direction < point_to and current_direction > point_to - PI:
				rotation_direction = 1
			else:
				rotation_direction = -1
	
	return rotation_direction
	
func set_rocket_direction():
	$Rocket.rotation = float_mod((get_viewport().get_mouse_position() - $Rocket.position).angle() + PI * 5/2, 2*PI)

#func on_upgrade_2_lasers():
#	$Rocket.turret_count = 2
#func on_upgrade_3_lasers():
#	$Rocket.turret_count = 3

func add_health(amt):
	$Rocket.change_health(amt)
func add_armor(max_health, health):
	$Rocket.max_health += max_health
	$Rocket.change_health(health)
func set_regen(val):
	$Rocket.set_regen(val)
func set_speed_level(val):
	$Rocket.set_speed_level(val)
func set_turret_count(amt):
	$Rocket.turret_count = amt

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
