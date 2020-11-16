extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 400
export var rotation_speed = 2.5
var screen_size


var velocity = Vector2()
var rotation_direction = 0

var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision()
	screen_size = get_viewport_rect().size
	speed = 550
	rotation_speed = 3
	
	position.x = screen_size.x/2
	position.y = screen_size.y/2
	
	$LaserTimer.start()

func _physics_process(delta):
#	get_input()
	
	rotation += rotation_direction * rotation_speed * delta
	
	if velocity == Vector2(0,0):
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = "default"
	else:
		$AnimatedSprite.animation = "flame"
		$AnimatedSprite.play()
		position += velocity * speed * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)

#func get_input():
#	velocity = Vector2()
#	rotation_direction = 0
#	if Input.is_action_pressed("up"):
#		velocity.y -= 1
#	if Input.is_action_pressed("down"):
#		velocity.y += 1
#	if Input.is_action_pressed("left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("right"):
#		velocity.x += 1
#	velocity = velocity.normalized()
#
#	if Input.is_action_pressed("rotate_left"):
#		rotation_direction -= 1
#	if Input.is_action_pressed("rotate_right"):
#		rotation_direction += 1
	
func set_input(vel, rotate):
	velocity = vel.normalized()
	rotation_direction = rotate

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
