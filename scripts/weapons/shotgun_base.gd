extends DTFirearm
class_name DTShotgun


func s_fire(base_dir, pangle, pellets, spread, velocity_variance, force):
	if .firecheck():
		var player = get_node("/root/root/Player")
		var pforce = player.get("force")
		if pangle:
			player.set("force", Vector2(pforce.x - force, pforce.y))
		else:
			player.set("force", Vector2(pforce.x + force, pforce.y))
		var z = 0
		var temp = bullet_velocity
		while z < pellets:
			bullet_velocity += rand_range(-velocity_variance, velocity_variance)
			._fire(base_dir + rand_range(-spread, spread), pangle)
			z += 1
		current_mag -= 1
		bullet_velocity = temp


func s_reload():
	.reload()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
