extends Node


# Declare member variables here.


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$AsteroidMain.start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
