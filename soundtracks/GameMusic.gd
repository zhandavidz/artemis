extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var songs
var current_song = "main_menu"

# Called when the node enters the scene tree for the first time.
func _ready():
	songs = {
		"main_menu": $NeonRenegadeCut,
		"game1": $HazelsComet
	}
	pass # Replace with function body.


func set_song(song):
	for child in get_children():
		if child.get_class() == "AudioStreamPlayer":
			print("yes")
			child.stop()
	print(songs[song])
#	songs[song].play()

func play():
	songs[current_song].play()
