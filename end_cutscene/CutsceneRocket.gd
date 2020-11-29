extends Node2D


func _ready():
	$Tween.interpolate_property( $Path2D/PathFollow2D, "unit_offset", 0, 1, 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

#func start_animation():
#
##	$Path2D/Tween.interpolate_property($Path2D/PathFollow2D, "unit_offset", 0, 1, 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
##	$Path2D/Tween.start()
#
#	$Tween.interpolate_property( $Path2D/PathFollow2D, "unit_offset", 0, 1, 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	$Tween.start()
