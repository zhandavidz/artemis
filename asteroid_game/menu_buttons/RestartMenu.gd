extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show():
	for child in get_children():
		child.show()

func hide():
	for child in get_children():
		child.hide()

func set_restart_only():
	$ResumeButton.hide()
	
	$RestartButton.show()
	$RestartButton.anchor_top = .4
	$RestartButton.anchor_bottom = .4
	$RestartButton.rect_position = Vector2(805, 387)
	
	$MainMenuButton.show()
	$MainMenuButton.anchor_top = .6
	$MainMenuButton.anchor_bottom = .6
	$MainMenuButton.rect_position = Vector2(755, 603)
	
	
func set_pause_menu():
	$ResumeButton.show()
	
	$RestartButton.show()
	$RestartButton.anchor_top = .5
	$RestartButton.anchor_bottom = .5
	$RestartButton.rect_position = Vector2(805, 495)
	
	$MainMenuButton.show()
	$MainMenuButton.anchor_top = .65
	$MainMenuButton.anchor_bottom = .65
	$MainMenuButton.rect_position = Vector2(755, 657)


func _on_ResumeButton_pressed():
	get_parent().resume_game()

func _on_RestartButton_pressed():
	get_parent().restart_game()


func _on_MainMenuButton_pressed():
	get_parent().end_game()
	get_node("/root/Main/MainMenu").show_main_menu()


