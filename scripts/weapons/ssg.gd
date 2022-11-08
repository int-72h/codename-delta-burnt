extends DTShotgun
const classname = "shotgun"
var _scene = preload("res://Scenes/Bullet.tscn")
var _shoot = preload("res://assets/shoot_1.wav")
var _reload = preload("res://assets/sfx_2.wav")
func _ready():
	get_node("/root/root/Player").connect("reload", self, "_on_reload")
	get_node("/root/root/Player").connect("fire", self, "_on_Player_fire")
	scene = _scene
	firing_sound = _shoot
	reload_sound = _reload
	damage = 5
	firing_speed = 0.1
	bullet_velocity = 20
	mag_size = 15
	reload_time = 0.5
	reserve_ammo = 48
	entropy = 15
	recoil = 20
	current_ammo = reserve_ammo
	current_mag = mag_size
	timer.one_shot = true

#since I can't put this in DTFirearm, it goes here.
func _on_Player_fire(direction, pangle):
	if self.is_inside_tree():
		print("%s/%s" % [current_mag, current_ammo])
		if self.is_inside_tree():
			.s_fire(direction, pangle, 4, rand_range(0.1, 0.5), rand_range(-0.5, 2))  #rads??? degs???


func _on_reload():
	if self.is_inside_tree():
		print("reloading!")
		.reload()
