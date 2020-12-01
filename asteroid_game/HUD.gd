extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PlayerRocket
var ingot_count = 0
var upgrades
var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pregame()

func set_pregame():
	PlayerRocket = get_node("/root/Main/AsteroidMain/PlayerRocket")
	reset_upgrades()
	ingot_count = 0
	$MetalCount.text = str(ingot_count)
	active = true
	

func _process(delta):
	for i in upgrades:
		if active:
	#		upgrades[upgrades[i]]["levels"]
			if upgrades[i]["allow_infinite_upgrades"]:
				upgrades[i]["node"].disabled = ingot_count < upgrades[i]["cost"]
			# not infinite levels and not max level
	#		elif not upgrades[i]["current_level"] > upgrades[i]["levels"].size():
			else:
				#not max level
				if not upgrades[i]["current_level"] > upgrades[i]["levels"].size():
					upgrades[i]["node"].disabled = ingot_count < upgrades[i]["levels"][upgrades[i]["current_level"]]
				# is max level
				else:
					upgrades[i]["node"].disabled = true
	#			if i == "laser":
	#				print("is max level: " + str(upgrades[i]["current_level"] > upgrades[i]["levels"].size()))
	#				print(upgrades[i]["current_level"])
	#				print(upgrades[i]["levels"].size())
	#				print()
	#				print(ingot_count < upgrades[i]["levels"][upgrades[i]["current_level"]])
			# not infinite levels and is max level
	#		else
		else:
			upgrades[i]["node"].disabled = true

func show():
	reset_upgrades()
	for child in get_children():
		child.show()
	
	# health bar
	$PlayerHealth.text = str("100")
#	$PlayerHealth.show()
	
	# metal hud stuff
#	$MetalIcon.show()
#	$MetalCount.show()
#	show_wave(1,5)

func hide():
	for child in get_children():
		child.hide()
#	$PlayerHealth.hide()


func change_metal_count(amt):
#	$MetalCount.text = str(int($MetalCount.text) + amt)
	ingot_count += amt
	$MetalCount.text = str(ingot_count)

func show_wave(wave, total):
	$WaveCount.text = "WAVE "+str(wave)+"/"+str(total)

func _on_UpgradeHealth_pressed():
	change_metal_count(-upgrades["health"]["cost"])
	PlayerRocket.add_health(5)


func _on_UpgradeArmor_pressed():
	change_metal_count(-upgrades["armor"]["cost"])
	PlayerRocket.add_armor(30, 20)


func _on_UpgradeRegen_pressed():
	if (not upgrades["regen"]["current_level"] > upgrades["regen"]["levels"].size()) and ingot_count >= upgrades["regen"]["levels"][upgrades["regen"]["current_level"]]:
		PlayerRocket.set_regen(upgrades["regen"]["regen_speeds"][upgrades["regen"]["current_level"]])
	upgrade_button("regen")


func _on_UpgradeSpeed_pressed():
	if (not upgrades["speed"]["current_level"] > upgrades["speed"]["levels"].size()) and ingot_count >= upgrades["speed"]["levels"][upgrades["speed"]["current_level"]]:
		PlayerRocket.set_speed_level(upgrades["speed"]["current_level"])
	upgrade_button("speed")


func _on_UpgradeLasers_pressed():
	# not max level and enough ingots
	if (not upgrades["laser"]["current_level"] > upgrades["laser"]["levels"].size()) and ingot_count >= upgrades["laser"]["levels"][upgrades["laser"]["current_level"]]:
		PlayerRocket.set_turret_count(upgrades["laser"]["current_level"]+1)
#		get_node("/root/Main/AsteroidMain/PlayerRocket").call("on_upgrade_"+str(upgrades["laser"]["current_level"]+1)+"_lasers")
	upgrade_button("laser")

func upgrade_button(upgrade):
#	if upgrades[upgrade]["allow_infinite_upgrades"]:
	# first if it is 
#	upgrades[upgrade]["current_level"] > upgrades[upgrade]["levels"].size()
	if ingot_count >= upgrades[upgrade]["levels"][upgrades[upgrade]["current_level"]]:
		# is max level size
#		print("\n"+upgrade + ":")
#		print(upgrades[upgrade]["current_level"])
#		print(upgrades[upgrade]["levels"].size())
#		print(upgrades[upgrade]["current_level"] >= upgrades[upgrade]["levels"].size())
		
		if upgrades[upgrade]["current_level"] == upgrades[upgrade]["levels"].size():
			print("true")
			set_image(upgrade, "max")
			change_metal_count(-upgrades[upgrade]["levels"][upgrades[upgrade]["current_level"]])
			upgrades[upgrade]["current_level"] += 1
		else:
			print(false)
			change_metal_count(-upgrades[upgrade]["levels"][upgrades[upgrade]["current_level"]])
			upgrades[upgrade]["current_level"] += 1
			set_image(upgrade, upgrades[upgrade]["current_level"])
	if upgrade == "laser":
		print(upgrades["laser"]["current_level"])

func reset_upgrades():
	upgrades = {
		"health": { # gives player 5 health
			"node": $UpgradeHealth,
			"cost": 1,
			"used": false,
#			"show_initially": true,
			"current_level": 1,
			"allow_infinite_upgrades": true
		},
		"armor": { # increases limit by 50 health and adds 50 health
			"node": $UpgradeArmor,
			"cost": 5,
#			"used": false,
#			"show_initially": true,
			"current_level": 1,
			"allow_infinite_upgrades": true
		},
		"regen": {
			"node": $UpgradeRegen,
			"levels": {
				1: 15,
				2: 30,
				3: 45
			},
			"regen_speeds": {
				1: 1.5,
				2: 1,
				3: .5
			},
#			"cost": 5,
#			"used": false,
#			"show_initially": true,
			"current_level": 1,
			"allow_infinite_upgrades": false
		},
		"speed": {
			"node": $UpgradeSpeed,
			"levels": {
				1: 20,
				2: 40,
				3: 60
			},
#			"cost": 5,
#			"used": false,
#			"show_initially": true,
			"current_level": 1,
			"allow_infinite_upgrades": false
		},
		"laser": {
			"node": $UpgradeLasers,
			"levels": {
				1: 30,
				2: 60
			},
#			"cost": 5,
#			"used": false,
#			"show_initially": true,
			"current_level": 1,
			"allow_infinite_upgrades": false
		}
	}
	
	setup_images()


func setup_images():
	for key in upgrades:
		set_image(key, 1)
#		upgrades[key]["node"].texture_normal = load("res://asteroid_game/hud_assets/"+key+"_upgrade/default_1.png")
#		upgrades[key]["node"].texture_pressed = load("res://asteroid_game/hud_assets/"+key+"_upgrade/pressed_1.png")
#		upgrades[key]["node"].texture_disabled = load("res://asteroid_game/hud_assets/"+key+"_upgrade/disabled_1.png")

func set_image(upgrade, level):
	if str(level) != "max":
		upgrades[upgrade]["node"].texture_pressed = load("res://asteroid_game/hud_assets/"+upgrade+"_upgrade/pressed_"+str(level)+".png")
	upgrades[upgrade]["node"].texture_normal = load("res://asteroid_game/hud_assets/"+upgrade+"_upgrade/default_"+str(level)+".png")
	upgrades[upgrade]["node"].texture_disabled = load("res://asteroid_game/hud_assets/"+upgrade+"_upgrade/disabled_"+str(level)+".png")

