extends DTFirearm
var _scene = preload("res://Bullet.tscn")


func _ready():
	get_node("/root/root/Player").connect("fire", self, "_on_Player_fire")
	get_node("/root/root/Player").connect("reload", self, "_on_reload")
	.init(_scene, 15, 0.2, 10, 7, 1, 100)


# This file is a simple stub specifing the firearms' damage types


#since I can't put this in DTFirearm, it goes here.
func _on_Player_fire(direction, pangle):
	print("%s/%s" % [current_mag, current_ammo])
	if self.is_inside_tree():
		.fire(direction, pangle)


func _on_reload():
	if self.is_inside_tree():
		print("reloading!")
		.reload()
