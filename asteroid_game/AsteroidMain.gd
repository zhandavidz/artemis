extends Node

# Declare member variables here. Examples:
export (PackedScene) var Laser = load("asteroid_game/laser_assets/Laser.tscn")
export (PackedScene) var Asteroid = load("asteroid_game/asteroid_assets/Asteroid.tscn")
export (PackedScene) var EnemyRocket = load("asteroid_game/rocket_assets/EnemyRocket.tscn")
export (PackedScene) var MetalIngot = load("asteroid_game/metal_assets/MetalIngot.tscn")
export (PackedScene) var MoonLandingAnimation = load("end_cutscene/MoonLandingAnimation.tscn")

var enemy_rockets = []
var metal_ingots = []
var paused = false

var current_wave = 1
var wave_prob = { # out of 10
	1: {
		"normal": 10,
		"reinforced": 0,
		"yellow": 0,
		"purple": 0
	},
	2: {
		"normal": 7,
		"reinforced": 3,
		"yellow": 0,
		"purple": 0
	},
	3: {
		"normal": 5,
		"reinforced": 3,
		"yellow": 2,
		"purple": 0
	},
	4: {
		"normal": 2,
		"reinforced": 2,
		"yellow": 3,
		"purple": 3
	},
	5: {
		"normal": 1,
		"reinforced": 2,
		"yellow": 3,
		"purple": 4
	}
}
var wave_prob_bounds = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pregame()

func set_pregame():
	print("asteroidmain")
	$HUD.hide()
	$HUD.set_pregame()
	$PlayerRocket.set_pregame()
	set_wave_prob_bounds()
	$RestartMenu.hide()
	paused = false

func start_game():
	$AsteroidTimer.start()
	$PlayerPositionInterval.start()
	$EnemySpawn.wait_time = 2
	$EnemySpawn.start()
	$HUD.show()
	$PlayerRocket.show()
	$PlayerRocket.start_game()
	for enemy in enemy_rockets:
		enemy.queue_free()
	enemy_rockets = []
	for ingot in metal_ingots:
		ingot.queue_free()
	metal_ingots = []
	$WaveTimer.set_paused(false)
	$WaveTimer.start()
	current_wave = 1
	$HUD.show_wave(current_wave, wave_prob_bounds.size())
	paused = false

func end_game():
	$AsteroidTimer.stop()
	$PlayerPositionInterval.stop()
	$EnemySpawn.stop()
	$HUD.hide()
	$PlayerRocket.end_game()
	$WaveTimer.stop()
	$RestartMenu.hide()
	current_wave = 1
	for enemy in enemy_rockets:
		if enemy != null:
			enemy.queue_free()
	enemy_rockets = []
	for ingot in metal_ingots:
		if ingot != null:
			ingot.queue_free()
	metal_ingots = []
	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		asteroid.queue_free()
		


func pause_game(mode="restart_only"):
	for enemy in enemy_rockets:
		if enemy != null:
			enemy.allow_shooting = false
			enemy.can_move = false
	
#	for asteroid in get_tree().get_nodes_in_group("asteroids"):
#		asteroid.sleeping = true
##		asteroid.mode = RigidBody2D.MODE_STATIC
#		asteroid.collision_mask = 0
#		asteroid.collision_layer = 0
	$AsteroidTimer.stop()
	$PlayerPositionInterval.stop()
	$EnemySpawn.stop()
#	$WaveTimer.set_active(false)
	$WaveTimer.set_paused(true)
	
	$RestartMenu.show()
	if mode == "pause":
		$RestartMenu.set_pause_menu()
	else: # mode == "lose"
		$RestartMenu.set_restart_only()
	$PlayerRocket.can_move = false
	$PlayerRocket.allow_shooting = false
	$HUD.active = false
	$PauseDelay.start()

func resume_game():
	for enemy in enemy_rockets:
		if enemy != null:
			enemy.allow_shooting = true
			enemy.can_move = true
	
#	for asteroid in get_tree().get_nodes_in_group("asteroids"):
#		asteroid.sleeping = false
##		asteroid.mode = RigidBody2D.MODE_STATIC
#		asteroid.collision_mask = 1
#		asteroid.collision_layer = 1
	$AsteroidTimer.start()
	$PlayerPositionInterval.start()
	$EnemySpawn.start()
	$WaveTimer.set_paused(false)
	
	$RestartMenu.hide()
	$PlayerRocket.can_move = true
	$PlayerRocket.allow_shooting = true
	$HUD.active = true
	$ResumeDelay.start()

func restart_game():
	end_game()
	get_node("/root/Main/MainMenu").show_main_menu()
	get_node("/root/Main/MainMenu")._on_PlayButton_pressed()

func update_player_health(health):
	if health < 0:
		health = 0
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
#	print(MetalIngot)
#	print(EnemyRocket)
	var ingot = MetalIngot.instance()
	add_child(ingot)
	ingot.position = pos
	metal_ingots.append(ingot)
#	pass


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
	var rand = randi()%10+1
#	for type in wave_prob_bounds[current_wave]:
#		if wave_prob_bounds[current_wave][type] <= rand:
#			enemy_rocket.type = type
#			print(str(current_wave)+":"+str(type)+":"+str(wave_prob_bounds[current_wave][type])+":"+str(rand))
#			break
	var total_prob = 0
	for type in wave_prob[current_wave]:
		total_prob += wave_prob[current_wave][type]
		if rand <= total_prob:
			enemy_rocket.type = type
#			print(str(current_wave)+":"+str(type)+":"+str(wave_prob_bounds[current_wave][type])+":"+str(rand))
			break
#	enemy_rocket.type = "normal"
	enemy_rockets.append(enemy_rocket)


func _on_WaveTimer_timeout():
	if current_wave < wave_prob_bounds.size():
		current_wave += 1
		$HUD.show_wave(current_wave, wave_prob_bounds.size())
		$EnemySpawn.wait_time -= .2
	else:
		end_game()
		get_node("/root/Main/MainMenu").show_moon_animation()


func set_wave_prob_bounds():
	for wave in wave_prob:
		wave_prob_bounds[wave] = {}
		var total_prob = 0
		for type in wave_prob[wave]:
			if total_prob == 10:
				wave_prob_bounds[wave][type] = 11 # 11 will never be less than 10, which is max of rand number, any number could work, 11 is just in case
			else:
				wave_prob_bounds[wave][type] = wave_prob[wave][type]
				total_prob += wave_prob[wave][type]



func _on_PauseDelay_timeout():
	paused = true


func _on_ResumeDelay_timeout():
	paused = false
