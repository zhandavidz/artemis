extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var music_node
export (PackedScene) var MoonLandingAnimation = load("end_cutscene/MoonLandingAnimation.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
#	music_node = get_node("/root/Main/GameMusic")
#
#	music_node.set_song("main_menu")
#	music_node.play()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
	hide_main_menu()
	$MenuSong.stop()
	get_parent().start_game()

func _on_QuitButton_pressed():
	get_tree().quit()



func _on_MenuSong_finished():
	$MenuSong.play()


func _on_ControlsButton_pressed():
#	$GameMusic.set_song("hi")
	pass

func _on_CreditsButton_pressed():
	pass

func hide_main_menu():
	for child in get_children():
		if child.has_method("hide"):
			child.hide()

func show_main_menu():
	for child in get_children():
		if child.has_method("show"):
			child.show()
	print(get_node("/root/Main/AsteroidMain"))
	get_node("/root/Main/AsteroidMain").set_pregame()

func show_moon_animation():
	add_child(MoonLandingAnimation.instance())
