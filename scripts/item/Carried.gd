extends Node2D
class_name DTCarried
var look_at_mouse := true


#change later
func look(set):
	look_at_mouse = set


func _process(delta):
	if look_at_mouse:
		look_at(get_global_mouse_position())
	pass
