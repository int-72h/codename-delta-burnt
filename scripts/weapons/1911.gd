extends DTFirearm
const classname = "1911"
var _scene = preload("res://Scenes/Bullet.tscn")
var _shoot = preload("res://assets/shoot_2.wav")
var _reload = preload("res://assets/sfx_2.wav")


func _ready():
	get_node("/root/root/Player").connect("fire", self, "_on_Player_fire")
	get_node("/root/root/Player").connect("reload", self, "_on_reload")
	scene = _scene
	firing_sound = _shoot
	reload_sound = _reload
	damage = 15
	firing_speed = 0.2
	bullet_velocity = 20
	mag_size = 7
	reload_time = 1
	entropy = 15
	reserve_ammo = 49
	recoil = 25
	# setup
	current_ammo = reserve_ammo
	current_mag = mag_size
	timer.one_shot = true

# This file is a simple stub specifing the firearms' damage types


#since I can't put this in DTFirearm, it goes here.
func _on_Player_fire(direction, pangle):
	if self.is_inside_tree():
		print("%s/%s" % [current_mag, current_ammo])
		if self.is_inside_tree():
			.fire(direction, pangle)


func _on_reload():
	if self.is_inside_tree():
		print("reloading!")
		.reload()

func on_hit(damage):
	get_node("/root/root/Player").call("on_hit",damage)
