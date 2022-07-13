extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_ammo(mag_ammo,res_ammo):
	$Ammo.text = "%s/%s" % [str(mag_ammo),str(res_ammo)]
func set_health(health):
	$Health.text = str(health)
func set_speed(speed):
	$Speed.text = str(round(speed))
