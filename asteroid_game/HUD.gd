extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PlayerRocket

# Called when the node enters the scene tree for the first time.
func _ready():
	var PlayerRocket = get_node("/root/Main/AsteroidMain/PlayerRocket")
	$Upgrade2Lasers.connect("pressed", PlayerRocket, "_on_upgrade_2_lasers")
	$Upgrade3Lasers.connect("pressed", PlayerRocket, "_on_upgrade_3_lasers")

func show():
	hide()
	$PlayerHealth.text = str("100")
	$PlayerHealth.show()
	$Upgrade2Lasers.show()
	pass

func hide():
	for child in get_children():
		child.hide()
#	$PlayerHealth.hide()
#	$Upgrade2Lasers.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Upgrade2Lasers_pressed():
	$Upgrade2Lasers.hide()
	$Upgrade3Lasers.show()


func _on_Upgrade3Lasers_pressed():
	$Upgrade3Lasers.disabled = true
