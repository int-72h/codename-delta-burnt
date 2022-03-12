extends DTCarried
class_name DTFirearm

#add more things
var scene: PackedScene
var damage: float
var firing_speed: float
var bullet_velocity: float
var reload_time: int
var current_ammo: int
var reserve_ammo: int
var mag_size: int
var current_mag: int
var spinamt: float
enum state{idle,firing,reloading}
var current_state: int
onready var timer = Timer.new()
func _ready():
	get_tree().get_root().call_deferred("add_child",timer)
	
func init(_scene,_damage,_firing_speed,_bullet_velocity,_magazine_size,_reload_time,_reserve_ammo): # the mother of all setters
	scene = _scene
	damage = _damage
	firing_speed = _firing_speed
	bullet_velocity = _bullet_velocity
	mag_size = _magazine_size
	reserve_ammo = _reserve_ammo
	current_ammo = reserve_ammo
	current_mag = _magazine_size
	reload_time = _reload_time
	timer.one_shot = true
	
func fire(direction,pangle):
	if firecheck():
		_fire(direction,pangle)
		current_mag -= 1
	
func firecheck():
	if current_state == state.idle and (current_mag > 0):
		current_state = state.firing
		timer.wait_time = firing_speed
		timer.start()
		return true
	else:
		return false

func reload():
	if current_state == state.idle:
		current_state = state.reloading
		timer.wait_time = reload_time
		timer.start()
		spinamt = (2*PI / reload_time)
		if current_ammo < mag_size:
			current_mag = current_ammo
		else:
			current_mag = mag_size
		current_ammo = current_ammo - current_mag
		
	

		
func _fire(direction,pangle):
	var bullet = scene.instance()
	bullet.init(bullet_velocity,direction,get_child(0).get_global_position(),pangle) # DTpoint, the muzzle
	if pangle:
		bullet.apply_scale(Vector2(0.05,0.05))
	else:
		bullet.apply_scale(Vector2(-0.05,0.05))
	get_node("/root/root").add_child(bullet)

func _physics_process(delta):
	if current_state == state.reloading:
		.look(false)
		self.rotate(spinamt*delta)
	if timer.is_stopped():
		.look(true)
		current_state = state.idle
