extends Node

# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
export (PackedScene) var Asteroid = load("asteroid_game/asteroid_assets/Asteroid.tscn")
export (PackedScene) var EnemyRocket = load("asteroid_game/rocket_assets/EnemyRocket.tscn")

var enemy_rockets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.hide()
	$PlayerRocket.set_pregame()

func start_game():
	$AsteroidTimer.start()
	$PlayerPositionInterval.start()
	$EnemySpawn.start()
	$HUD.show()
	$PlayerRocket.start_game()
	for enemy in enemy_rockets:
		enemy.queue_free()
	enemy_rockets = []

func end_game():
	$AsteroidTimer.stop()
	$PlayerPositionInterval.stop()
	$EnemySpawn.stop()
	$HUD.hide()
#	for enemy in enemy_rockets:
#		enemy.queue_free()
#	enemy_rockets = []

func update_player_health(health):
	$HUD/PlayerHealth.text = str(health)


func _on_AsteroidTimer_timeout():
	# make a new asteroid
	var asteroid = Asteroid.instance()
	add_child(asteroid)


func _on_PlayerPositionInterval_timeout():
	for enemy in enemy_rockets:
		enemy.set_target($PlayerRocket/Rocket.position)


func _on_EnemySpawn_timeout():
	var enemy_rocket = EnemyRocket.instance()
	add_child(enemy_rocket)
	enemy_rocket.type = "yellow"
	enemy_rockets.append(enemy_rocket)
