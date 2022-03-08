extends DTCarried
class_name DTFirearm

#add more things
var scene
var damage
var firing_speed
var bullet_velocity

func init(_scene,_damage,_firing_speed,_bullet_velocity):
	scene = _scene
	damage = _damage
	firing_speed = _firing_speed
	bullet_velocity = _bullet_velocity

func fire(direction,pangle):
	var bullet = scene.instance()
	bullet.init(bullet_velocity,direction,get_node("DTPoint").get_global_position(),pangle)
	if pangle:
		bullet.apply_scale(Vector2(0.05,0.05))
	else:
		bullet.apply_scale(Vector2(-0.05,0.05))
	get_tree().get_root().add_child(bullet)
