extends Node2D


# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var velocity = Vector2()
	var rotation_direction = 0
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
#	velocity = velocity.normalized()
	
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	
	$Rocket.set_input(velocity, rotation_direction)
	
	if Input.is_action_pressed("shoot"):
		if $Rocket.can_shoot:
			$Rocket.can_shoot = false
			var laser = Laser.instance()
			add_child(laser)
			laser.shoot("player", $Rocket.position, $Rocket.rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
