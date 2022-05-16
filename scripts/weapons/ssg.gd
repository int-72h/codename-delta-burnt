extends DTShotgun

var _scene = preload("res://Bullet.tscn")
func _ready():
	get_node("/root/root/Player").connect("reload",self,"_on_reload")
	get_node("/root/root/Player").connect("fire",self,"_on_Player_fire")
	.init(_scene, 5, 2, 15, 2, 3, 48)



#since I can't put this in DTFirearm, it goes here.
func _on_Player_fire(direction,pangle):
	print("%s/%s" % [current_mag,current_ammo])
	if self.is_inside_tree():
		.s_fire(direction,pangle,8,0.5)

func _on_reload():
	if self.is_inside_tree():
		print("reloading!")
		.reload()
