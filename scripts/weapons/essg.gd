extends DTShotgun

var _scene = preload("res://Scenes/Bullet.tscn")

func _ready():
	look_at_mouse = false # sets the carried function to not look
	look = false # sets the weapon func to not reenable looking after reloading
	.init(_scene, 5, 0.1, 20, 15, 0.5, 48,15)  #scne,dmg,firespd,bulvel,magsz,rlt,rzammo,ent


#since I can't put this in DTFirearm, it goes here.
func fire(direction, pangle):
	print("%s/%s" % [current_mag, current_ammo])
	if self.is_inside_tree():
		.s_fire(direction, pangle, 4, rand_range(0.1, 0.5), rand_range(-0.5, 2), 100000)  #rads??? degs???


func reload():
	if self.is_inside_tree():
		print("reloading!")
		.reload()
