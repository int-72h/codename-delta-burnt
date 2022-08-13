extends CanvasLayer

var current_weapon
onready var player_node = get_node("/root/root/Player/Abilities")
var ability_active = [0,0,0] # inefficient
var good_face = load("res://assets/good_face_placeholder.png")
var med_face = load("res://assets/medium_face_placeholder.png")
var bad_face = load("res://assets/bad_face_placeholder.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_ammo():
	$MagBar.max_value = float(current_weapon.get("mag_size"))
	$MagBar.value = float(current_weapon.get("current_mag"))
	$AmmoBar.max_value = float(current_weapon.get("reserve_ammo"))
	$AmmoBar.value = float(current_weapon.get("current_ammo"))
func set_health(health):
	$HealthBar.value = float(health)
func set_speed(speed):
	$SpeedBar.value = abs(speed)
func set_firearm(firearm):
	current_weapon=firearm
	$ReloadBar.max_value = current_weapon.get("reload_time")
func set_consts(consts):
	for x in range(0,len(consts)):
		get_node("ConstBar"+str(x)).value = consts[x]
func _process(_delta):
	hud_ability_tick()
	if current_weapon.get("current_state") == 2: # ok what you need to do is get the firearm linked to an enum in the player- then read off of that and get the player to emit the signal???
		$MagBar.hide()
		$MagLabel.hide()
		$AmmoBar.hide()
		$AmmoLabel.hide()
		$ReloadBar.value = current_weapon.get("reload_time_left") #awful code moment 10000
		$ReloadBar.show()
		$ReloadLabel.show()
		$AmmoBar.show()
		$AmmoLabel.show()
		$MagBar.show()
		$MagLabel.show()
	else:
		$ReloadBar.hide()
		$ReloadLabel.hide()
	if current_weapon.get("current_state") == 1 or  current_weapon.get("current_state") ==  2:
		$Face.texture = med_face
	elif $HealthBar.value < 25:
		$Face.texture = bad_face
	else:
		$Face.texture = good_face
		
func set_debug(text):
	$DebugLabel.text = text

func hud_ability_tick():  # massively inflexible fix later 
		var arr = player_node.get("ability_array")
		var timers = player_node.get("ability_timers")
		for x in range(0,len(arr)):
			var bar = get_node("AbilityBar" + str(x))
			bar.max_value = timers[x].wait_time
			bar.value = timers[x].time_left
		
func _on_abl_ability_ready(id): 
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(255,255,255))

func _on_abl_ability_start(id):
	ability_active[id] = 1
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(50,129,0))

func _on_abl_ability_stop(id):
	ability_active[id] = 0
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(0,0,255))


func _on_abl_ability_not_ready(id):
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(0,0,0))
