extends Node

# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
export (PackedScene) var Asteroid = load("asteroid_game/asteroid_assets/Asteroid.tscn")
export (PackedScene) var EnemyRocket = load("asteroid_game/rocket_assets/EnemyRocket.tscn")
export (PackedScene) var MetalIngot = load("asteroid_game/metal_assets/MetalIngot.tscn")

var enemy_rockets = []
var metal_ingots = []

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

func is_on_ingot(pos):
	for ingot in get_tree().get_nodes_in_group("ingots"):
		if (not ingot.picked_up) and ((ingot.position.x - 32 <= pos.x + 48 and pos.x - 48 <= ingot.position.x + 32) and (ingot.position.y - 32 <= pos.y + 64 and pos.y - 64 <= ingot.position.y + 32)):
#		if (pos.x + 48 <= ingot.position.x - 32 and ingot.position.x + 32 <= pos.x - 48) and (pos.y + 64 <= ingot.position.y - 32 and ingot.position.y + 32 <= pos.y - 64):
			ingot.picked_up = true
			$HUD.change_metal_count(1)
			ingot.queue_free()
	
#	var remove_indexs = []
#	for ingot_i in metal_ingots.size():
#		var ingot = metal_ingots[ingot_i]
#		if ingot != null:
#			if (not ingot.picked_up) and ((ingot.position.x - 32 <= pos.x + 48 and pos.x - 48 <= ingot.position.x + 32) and (ingot.position.y - 32 <= pos.y + 64 and pos.y - 64 <= ingot.position.y + 32)):
#				ingot.picked_up = true
#				$HUD.change_metal_count(1)
#	#			remove_indexs.append(ingot_i)
#				ingot.queue_free()
#	for ingot_i in metal_ingots.size():
#		if metal_ingots[ingot_i] == null:
#			metal_ingots.remove(ingot_i)
#	for i in remove_indexs:
#		metal_ingots.remove(i)

func add_ingot(pos):
	var ingot = MetalIngot.instance()
	add_child(ingot)
	ingot.position = pos
	metal_ingots.append(ingot)


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
	enemy_rocket.type = "normal"
	enemy_rockets.append(enemy_rocket)
