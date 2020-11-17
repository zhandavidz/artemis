extends RigidBody2D


# Declare member variables here. Examples:
export var speed = 150
var screen_size
var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("asteroids")
	
	screen_size = get_viewport_rect().size
	position = Vector2(randi() % int(screen_size.x - 100) + 50, -100)
	linear_velocity = Vector2(0, speed).rotated(rand_range(-1.5,1.5))
	
	
	set_asteroid_type()
	set_no_gravity_defaults()
	

func set_asteroid_type():
	$AnimatedSprite.stop()
	var sprite_num = randi() % 4
	$AnimatedSprite.animation = "asteroid_" + str(sprite_num)
	if sprite_num == 0:
		$CollisionShape2D.shape.radius = 55
	elif sprite_num == 1:
		$CollisionShape2D.shape.radius = 50
	elif sprite_num == 2:
		$CollisionShape2D.shape.radius = 60
	elif sprite_num == 3:
		$CollisionShape2D.shape.radius = 50
	else:
		print("unable to get a sprite")
		$CollisionShape2D.shape.radius = 55
		$AnimatedSprite.animation = "asteroid_0"
	
	$VisibilityNotifier2D.set_rect(Rect2(-60,-60,120,120))

func set_no_gravity_defaults():
	gravity_scale = 0
	mass = 100
	weight = mass * 9.81
	linear_damp = 0
	angular_damp = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


#func _on_Asteroid_body_entered(body):
#	print(health)
#	if body.is_in_group("lasers"):
#		health -= 1
#	elif body.is_in_group("rockets"):
#		health -= 2
#	check_health()

func check_health():
	if health <= 0:
		queue_free()
