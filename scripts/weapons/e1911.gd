extends DTFirearm
var _scene = preload("res://Scenes/Bullet.tscn")


func _ready():
	look_at_mouse = false
	look = false
	.init(_scene, 15, 0.2, 10, 7, 1, 100,1.5)


# This file is a simple stub specifing the firearms' damage types


#since I can't put this in DTFirearm, it goes here.
func fire(direction, pangle):
	if self.is_inside_tree():
		.fire(direction, pangle)


func reload():
	if self.is_inside_tree():
		.reload()
