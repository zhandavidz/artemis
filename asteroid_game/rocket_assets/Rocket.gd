extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 550
export var rotation_speed = 3
var screen_size

var health = 100

var velocity = Vector2()
var rotation_direction = 0
var clamp_on = true

var can_shoot = true

var animations = {
	"player": {
		"default": "player_default",
		"flame": "player_flame"
	},
	"enemy": {
		"default": "enemy_default",
		"flame": "enemy_flame"
	}
}

var type = "player"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("rockets")
	set_collision()
	screen_size = get_viewport_rect().size
	
	position.x = screen_size.x/2
	position.y = 2 * screen_size.y/3
	
	$LaserTimer.start()

func _physics_process(delta):
#	get_input()
	
	rotation += rotation_direction * rotation_speed * delta
	
	if velocity == Vector2(0,0):
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = animations[type]["default"]
	else:
		$AnimatedSprite.animation = animations[type]["flame"]
		$AnimatedSprite.play()
		position += velocity * speed * delta
		if clamp_on:
			position.x = clamp(position.x, 0, screen_size.x)
			position.y = clamp(position.y, 0, screen_size.y)

func set_speed(linear_speed, rot_speed=-1):
	speed = linear_speed
	if rot_speed == -1:
		rotation_speed = speed / 180.0
	else:
		rotation_speed = rot_speed
	
func set_input(vel, rotate):
	velocity = vel.normalized()
	rotation_direction = rotate

func set_direction(dir):
	rotation = dir

func set_enemy():
	type = "enemy"

func set_collision():
	pass
#	$CollisionPolygon2D.polygon.set(0, Vector2(0,-65))
#	$CollisionPolygon2D.polygon.set(1, Vector2(30,-23))
#	$CollisionPolygon2D.polygon.set(2, Vector2(30,10))
#	$CollisionPolygon2D.polygon.set(3, Vector2(48,28))
#	$CollisionPolygon2D.polygon.set(4, Vector2(48,52))
#	$CollisionPolygon2D.polygon.set(5, Vector2(30,32))
#	$CollisionPolygon2D.polygon.set(6, Vector2(-30,32))
#	$CollisionPolygon2D.polygon.set(7, Vector2(-48,52))
#	$CollisionPolygon2D.polygon.set(8, Vector2(-48,28))
#	$CollisionPolygon2D.polygon.set(9, Vector2(-30,10))
#	$CollisionPolygon2D.polygon.set(10, Vector2(-30,-23))


func _on_LaserTimer_timeout():
	can_shoot = true

func decrease_health(amt):
	health -= amt
#	if is_in_group("player"):
#		get_parent().get_parent().set_hud_health()

func check_health():
	print(is_in_group("players"))
	print(get_parent().is_in_group("players"))
	if health <= 0:
		get_parent().get_parent().enemy_rockets.erase(get_parent())
		get_parent().queue_free()
	elif is_in_group("players"):
		get_parent().get_parent().update_player_health(health)
