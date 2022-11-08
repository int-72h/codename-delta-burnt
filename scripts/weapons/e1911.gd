extends DTFirearm
var _scene = preload("res://Scenes/Bullet.tscn")
var _shoot = preload("res://assets/shoot_2.wav")
var _reload = preload("res://assets/shoot_2.wav")

func _ready():
	look_at_mouse = false
	look = false
	scene = _scene
	firing_sound = _shoot
	reload_sound = _reload
	damage = 15
	firing_speed = 0.2
	bullet_velocity = 20
	mag_size = 7
	reload_time = 1
	entropy = 15
	recoil = 5
	#.init(_scene, 15, 0.2, 10, 7, 1, 100,sound,_reload,1.5)
	current_ammo = reserve_ammo
	current_mag = mag_size
	timer.one_shot = true


# This file is a simple stub specifing the firearms' damage types


#since I can't put this in DTFirearm, it goes here.
func fire(direction, pangle):
	if self.is_inside_tree():
		.fire(direction, pangle)


func reload():
	if self.is_inside_tree():
		.reload()
