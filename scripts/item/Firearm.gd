extends DTCarried
class_name DTFirearm

#add more things
var scene: PackedScene
var firing_sound
var reload_sound
var damage: float
var firing_speed: float
var bullet_velocity: float
var reload_time: float
var current_ammo: int
var reserve_ammo: int
var mag_size: int
var current_mag: int
var spinamt: float
var entropy: float
var recoil: int
var look: bool = true
enum state { idle = 0, firing = 1, reloading = 2}
var current_state: int = 0
var reload_time_left: float
var owner_id
onready var timer = Timer.new()

signal const_change(type,val)

func _ready():
	get_tree().get_root().call_deferred("add_child", timer)

func fire(direction, pangle):
	if firecheck():
		$AudioStreamPlayer.stream = firing_sound
		$AudioStreamPlayer.play()
		print(firing_sound)
		_fire(direction, pangle)
		current_mag -= 1
		emit_signal("const_change",0,entropy)


func firecheck():
	if current_state == state.idle and (current_mag > 0):
		current_state = state.firing
		print("FIRING!")
		timer.wait_time = firing_speed
		timer.start()
		return true
	else:
		print(current_state)
		return false


func reload():
	if current_state == state.idle:
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
	bullet.init(bullet_velocity, direction, get_child(0).get_global_position(), pangle, damage,owner_id)  # DTpoint, the muzzle
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
