extends DTFirearm
var _scene = preload("res://Bullet.tscn")
func _ready():
	.init(_scene, 15, 0.5, 10)
# This file is a simple stub specifing the firearms' damage types. -h



#since I can't put this in DTFirearm, it goes here.
func _on_Player_fire(direction,pangle):
	.fire(direction,pangle)
