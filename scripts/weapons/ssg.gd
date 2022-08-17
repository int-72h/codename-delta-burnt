extends DTShotgun
const classname = "shotgun"
var _scene = preload("res://Scenes/Bullet.tscn")


func _ready():
	get_node("/root/root/Player").connect("reload", self, "_on_reload")
	get_node("/root/root/Player").connect("fire", self, "_on_Player_fire")
	.init(_scene, 5, 0.1, 20, 15, 0.5, 48,15)  #scne,dmg,firespd,bulvel,magsz,rlt,rzammo,ent


#since I can't put this in DTFirearm, it goes here.
func _on_Player_fire(direction, pangle):
	print("%s/%s" % [current_mag, current_ammo])
	if self.is_inside_tree():
		.s_fire(direction, pangle, 4, rand_range(0.1, 0.5), rand_range(-0.5, 2), 100000)  #rads??? degs???


func _on_reload():
	if self.is_inside_tree():
		print("reloading!")
		.reload()
