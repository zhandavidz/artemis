extends RigidBody2D


# Declare member variables here. Examples:
export var speed = 2000
var colors = {"player": "green", "enemy": "red"}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("lasers")
	gravity_scale = 0
	mass = 1
	weight = mass * 9.81
	linear_damp = 0
	angular_damp = 0
	
	contact_monitor = true
	contacts_reported = 1
	z_index = -1


func shoot(side, rocket_position, rocket_rotation):
	add_to_group(side)
	$AnimatedSprite.animation = colors[side]
	$GreenLaserSound.play()
	position = rocket_position + Vector2(0, -70).rotated(rocket_rotation)
	rotation = rocket_rotation
	
	linear_velocity = Vector2(speed, 0).rotated(rotation - PI / 2)



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_Laser_body_entered(body):
	if body.is_in_group("asteroids") or body.is_in_group("enemy"):
		queue_free()

