extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 550
export var rotation_speed = 3
var screen_size

#var health setget set_health, get_health
var health = 100
var max_health = health

var velocity = Vector2()
var rotation_direction = 0
var clamp_on = true

var can_shoot = true

var turret_count = 1
var current_turrets setget set_current_turrets, get_current_turrets

var player_speeds = {
	0: 550,
	1: 700,
	2: 850,
	3: 1000,
	4: 1150,
	5: 1300
}

var animations = {
	"player": {
		"default": "player_default",
		"flame": "player_flame"
	},
	"enemy": {
		"default": "enemy_default",
		"flame": "enemy_flame"
	},
	"reinforced_enemy": {
		"default": "reinforced_enemy_default",
		"flame": "reinforced_enemy_flame"
	},
	"yellow_enemy": {
		"default": "yellow_enemy_default",
		"flame": "yellow_enemy_flame"
	},
	"purple_enemy": {
		"default": "purple_enemy_default",
		"flame": "purple_enemy_flame"
	}
}

var turret_locations = { # call by [num turrets][which turret]
	1: {
		1: Vector2(0, -80)
	},
	2: {
		1: Vector2(-5, -80),
		2: Vector2(5, -80)
	},
	3: {
		1: Vector2(-10, -80),
		2: Vector2(0, -80),
		3: Vector2(10, -80)
	}
}

var type setget set_type

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("rockets")
	screen_size = get_viewport_rect().size
#	self.type = "player"
	
	position.x = screen_size.x/2
	position.y = 2 * screen_size.y/3
	
	set_pregame()

func set_pregame():
	show()
	$LaserTimer.start()
	$RegenCounter.stop()
	
	health = 100
	max_health = health

	velocity = Vector2()
	rotation_direction = 0
	clamp_on = true

	can_shoot = true

	turret_count = 1

func _physics_process(delta):
	
	rotation += rotation_direction * rotation_speed * delta
	
	if velocity != Vector2(0,0) or get_parent().can_move != true:
		$AnimatedSprite.animation = animations[type]["flame"]
		$AnimatedSprite.play()
		position += velocity * speed * delta
		if clamp_on:
			position.x = clamp(position.x, 0, screen_size.x)
			position.y = clamp(position.y, 0, screen_size.y)
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = animations[type]["default"]

	
func set_input(vel, rotate):
	velocity = vel.normalized()
	rotation_direction = rotate

func set_direction(dir):
	rotation = dir

func set_enemy():
	type = "enemy"



func _on_LaserTimer_timeout():
	can_shoot = true

#func decrease_health(amt):
#	health -= amt
#	if is_in_group("player"):
#		get_parent().get_parent().set_hud_health()

func check_health():
#	print(is_in_group("players"))
#	print(get_parent().is_in_group("players"))
	if health <= 0:
		if is_in_group("players"):
			get_parent().hide()
			hide()
			get_node("/root/Main/AsteroidMain").pause_game()
		elif is_in_group("enemies"):
			get_node("/root/Main/AsteroidMain").add_ingot(position)
			get_parent().get_parent().enemy_rockets.erase(get_parent())
			get_parent().queue_free()
	if is_in_group("players"):
		get_parent().get_parent().update_player_health(health)

func set_type(val):
	type = val
	if val == "player":
		speed = player_speeds[0]
		rotation_speed = 3
		add_to_group("players")
		turret_count = 2
	else:
		add_to_group("enemies")
		get_parent().set_shooting_timers(3,3)
		if val == "enemy":
			speed = 250
			rotation_speed = 2
			health = 10
			max_health = health
			turret_count = 1
#			get_parent().set_shooting_timers(3,3)
		elif val == "reinforced_enemy": # slow, more health
			speed = 150
			rotation_speed = .5
			health = 20
			max_health = health
			turret_count = 1
#			get_parent().set_shooting_timers(5,5)
		elif val == "yellow_enemy": # faster, 2 lasers
			speed = 300
			rotation_speed = 2.5
			health = 12
			max_health = health
			turret_count = 2
#			get_parent().set_shooting_timers(4,2.5)
		elif val == "purple_enemy": # even faster, 2 lasers
			speed = 350
			rotation_speed = 3
			health = 14
			max_health = health
			turret_count = 3
#			get_parent().set_shooting_timers(5,2)

func set_current_turrets(val):
	pass

func get_current_turrets():
	return turret_locations[turret_count]
func set_speed_level(val):
	print("\n"+str(speed))
	speed = player_speeds[val]
	print(val)
	print(speed)

func change_health(amt):
	health += amt
	if health > max_health:
		health = max_health
	check_health()

func set_regen(time):
	$RegenCounter.wait_time = time
	$RegenCounter.start()


func _on_RegenCounter_timeout():
	change_health(1)
