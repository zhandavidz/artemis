extends Node2D


# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
var is_shooting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$IsShootingTimer.start()
	position.y -= 100

func _physics_process(delta):
	var velocity = Vector2(randi()%3-1,randi()%3-1)
#	var velocity = Vector2()
	var rotation_direction = 1
	
	$Rocket.set_input(velocity, rotation_direction)
	
	if is_shooting:
		if $Rocket.can_shoot:
			$Rocket.can_shoot = false
			var laser = Laser.instance()
			add_child(laser)
			laser.shoot("enemy", $Rocket.position, $Rocket.rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_IsShootingTimer_timeout():
	is_shooting = not is_shooting
