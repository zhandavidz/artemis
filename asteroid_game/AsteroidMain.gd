extends Node

# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
export (PackedScene) var Asteroid = load("asteroid_game/asteroid_assets/Asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start_game():
	$AsteroidTimer.start()

func end_game():
	$AsteroidTimer.stop()


func _physics_process(delta):
	pass
#	if Input.is_action_pressed("shoot"):
#		if $PlayerRocket/Rocket.can_shoot:
#			$PlayerRocket/Rocket.can_shoot = false
#			var laser = Laser.instance()
#			add_child(laser)
#			laser.shoot("player", $PlayerRocket/Rocket.position, $PlayerRocket/Rocket.rotation)


func _on_AsteroidTimer_timeout():
	# make a new asteroid
	var asteroid = Asteroid.instance()
	add_child(asteroid)
