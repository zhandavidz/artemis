extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PlayerRocket
var ingot_count = 0
onready var upgrades = {
	"laser_2": {
		"cost": 5,
		"node": $Upgrade2Lasers,
		"used": false,
		"show_initially": true
	},
	"laser_3": {
		"cost": 25,
		"node": $Upgrade3Lasers,
		"used": false,
		"show_initially": false
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var PlayerRocket = get_node("/root/Main/AsteroidMain/PlayerRocket")
#	$Upgrade2Lasers.connect("pressed", PlayerRocket, "_on_upgrade_2_lasers")
#	$Upgrade3Lasers.connect("pressed", PlayerRocket, "_on_upgrade_3_lasers")

func _process(delta):
	for i in upgrades:
		var upgrade = upgrades[i]
		if not upgrade["used"]:
			upgrade["node"].disabled = ingot_count < upgrade["cost"]

func show():
	for i in upgrades:
		var upgrade = upgrades[i]
		if upgrade["show_initially"]:
			upgrade["node"].show()
		else:
			upgrade["node"].hide()
	
	# health bar
	$PlayerHealth.text = str("100")
	$PlayerHealth.show()
	
	# metal hud stuff
	$MetalIcon.show()
	$MetalCount.show()

func hide():
	for child in get_children():
		child.hide()
#	$PlayerHealth.hide()
#	$Upgrade2Lasers.hide()

func change_metal_count(amt):
#	$MetalCount.text = str(int($MetalCount.text) + amt)
	ingot_count += amt
	$MetalCount.text = str(ingot_count)


func _on_Upgrade2Lasers_pressed():
	if ingot_count >= upgrades["laser_2"]["cost"]:
		upgrades["laser_2"]["used"] = true
		get_node("/root/Main/AsteroidMain/PlayerRocket").on_upgrade_2_lasers()
		$Upgrade2Lasers.hide()
		$Upgrade3Lasers.show()
		change_metal_count(-upgrades["laser_2"]["cost"])


func _on_Upgrade3Lasers_pressed():
	if ingot_count >= upgrades["laser_3"]["cost"]:
		upgrades["laser_3"]["used"] = true
		get_node("/root/Main/AsteroidMain/PlayerRocket").on_upgrade_3_lasers()
		$Upgrade3Lasers.disabled = true
		change_metal_count(-upgrades["laser_3"]["cost"])
