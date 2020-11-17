extends Node

# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
export (PackedScene) var Asteroid = load("asteroid_game/asteroid_assets/Asteroid.tscn")
export (PackedScene) var EnemyRocket = load("asteroid_game/rocket_assets/EnemyRocket.tscn")

var enemy_rockets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start_game():
	$AsteroidTimer.start()
	$PlayerPositionInterval.start()
	$EnemySpawn.start()
	$HUD.show()

func end_game():
	$AsteroidTimer.stop()
	$PlayerPositionInterval.stop()
	$EnemySpawn.stop()
	$HUD.hide()

func update_player_health(health):
	$HUD/PlayerHealth.text = str(health)

#func _physics_process(delta):
#	pass
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


func _on_PlayerPositionInterval_timeout():
	for enemy in enemy_rockets:
#		if enemy is null:
#			enemy_rockets.erase()
		enemy.set_target($PlayerRocket/Rocket.position)


func _on_EnemySpawn_timeout():
	var enemy_rocket = EnemyRocket.instance()
	add_child(enemy_rocket)
	enemy_rockets.append(enemy_rocket)
