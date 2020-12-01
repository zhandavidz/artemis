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


func _on_RestartButton_pressed():
	get_parent().restart_game()


func _on_MainMenuButton_pressed():
	get_parent().end_game()
	get_node("/root/Main/MainMenu").show_main_menu()
