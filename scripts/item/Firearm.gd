extends DTCarried
class_name DTFirearm

#add more things
export var weapon_name: String
export var scene: PackedScene
export var firing_sound: AudioStreamSample
export var reload_sound: AudioStreamSample
export var damage: float
export var firing_speed: float
export var bullet_velocity: float
export var reload_time: float
var current_ammo: int
export var reserve_ammo: int
export var mag_size: int
var current_mag: int
var spinamt: float
export var entropy: float
export var recoil: int
export var shotgun: bool
export var velocity_variance: float
export var spread: float
export var pellets: int
var look: bool = true

var current_state: int = 0
var reload_time_left: float
onready var timer = Timer.new()


enum state { idle = 0, firing = 1, reloading = 2, cooldown = 3}


signal wep_fire(recoil,entropy)
signal const_change(type,val)

func _ready():
	current_ammo = reserve_ammo
	current_mag = mag_size
	timer.one_shot = true
	get_tree().get_root().call_deferred("add_child", timer)

func fire(direction, pangle):
	if firecheck():
		$AudioStreamPlayer.stream = firing_sound
		$AudioStreamPlayer.play()
		print(firing_sound)
		if shotgun:
			s_fire(direction,pangle,pellets,spread,velocity_variance)
		else:
			_fire(direction, pangle)
		current_mag -= 1
		emit_signal("const_change",0,entropy) # nobody recieves this!!!
		emit_signal("wep_fire",recoil,entropy)




func s_fire(base_dir, pangle, pellets, spread, velocity_variance):
		var z = 0
		var temp = bullet_velocity
		while z < pellets:
			bullet_velocity += rand_range(-velocity_variance, velocity_variance)
			_fire(base_dir + rand_range(-spread, spread), pangle)
			z += 1
		current_mag -= 1
		bullet_velocity = temp
		emit_signal("wep_fire",recoil,entropy)

func firecheck():
	if current_state == state.idle and (current_mag > 0) and is_inside_tree():
		current_state = state.firing
		print("FIRING!")
		$AnimatedSprite.play()
		$CPUParticles2D.emitting = true
		timer.wait_time = firing_speed
		timer.start()
		current_state = state.cooldown
		$CPUParticles2D.emitting = false
		$CPUParticles2D.restart()
		$AnimatedSprite.play("default",true)
		return true
	else:
		print(current_state)
		return false


func reload():
	if current_state == state.idle and is_inside_tree():
		if current_ammo == 0 or current_mag == mag_size:
			return
		current_state = state.reloading
		timer.wait_time = reload_time
		timer.start()
		$AudioStreamPlayer.stream = reload_sound
		$AudioStreamPlayer.play()
		var tween = get_tree().create_tween()
		tween.tween_property(self,"rotation",rotation + 2*PI,reload_time)
		print(reload_time)
		var ammo_needed = mag_size - current_mag
		if current_ammo <= ammo_needed:
			current_mag += current_ammo
			current_ammo = 0
		else:	
			current_mag = mag_size
			current_ammo = current_ammo - ammo_needed


func _fire(direction, pangle):
	var bullet = scene.instance()
	bullet.init(bullet_velocity, direction, get_child(0).get_global_position(), pangle, damage,0)  # DTpoint, the muzzle
	if pangle:
		bullet.apply_scale(Vector2(0.05, 0.05))
	else:
		bullet.apply_scale(Vector2(-0.05, 0.05))
	get_node("/root/root").add_child(bullet)


func _physics_process(_delta):
	reload_time_left = timer.time_left
	if current_state == state.reloading:
		.look(false)
	if timer.is_stopped():
		if look:
			.look(true)
		#print("we aren't firing")
		current_state = state.idle
func on_hit(dmg):
	get_parent().get_parent().call("on_hit",dmg)
