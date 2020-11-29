extends Node


# Declare member variables here.
var game_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func start_game():
	game_running = true
	$AsteroidMain.start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
