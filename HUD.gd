extends CanvasLayer

var current_weapon
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_ammo():
	$AmmoBar.max_value = float(current_weapon.get("mag_size"))
	$AmmoBar.value = float(current_weapon.get("current_mag"))
func set_health(health):
	$HealthBar.value = float(health)
func set_speed(speed):
	$SpeedBar.value = abs(speed)
func set_firearm(firearm):
	current_weapon=firearm
	$ReloadBar.max_value = current_weapon.get("reload_time")
func set_entropy(entropy):
	$ConstBar.value = entropy
func _process(_delta):
	if current_weapon.get("current_state") == 2:
		$AmmoBar.hide()
		$AmmoLabel.hide()
		$ReloadBar.value = current_weapon.get("reload_time_left") #awful code moment 10000
		$ReloadBar.show()
		$ReloadLabel.show()
	else:
		$ReloadBar.hide()
		$ReloadLabel.hide()
		$AmmoBar.show()
		$AmmoLabel.show()
		
func set_debug(text):
	$DebugLabel.text = text
