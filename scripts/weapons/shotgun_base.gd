extends DTFirearm
class_name DTShotgun

func s_fire(base_dir,pangle,pellets,spread):
	if .firecheck():
		var z = 0
		while z < pellets:
			._fire(base_dir + rand_range(-spread,+spread),pangle)
			z+=1
		current_mag -=1
func s_reload():
	.reload()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
