extends CanvasLayer

var current_weapon
onready var player_node = get_node("/root/root/Player/Abilities")
var ability_active = [0,0,0] # inefficient
var good_face = load("res://assets/good_face_placeholder.png")
var med_face = load("res://assets/medium_face_placeholder.png")
var bad_face = load("res://assets/bad_face_placeholder.png")
onready var text_timer = Timer.new()
onready var weapon_icons = {"1911":load("res://assets/gun_placeholder_2.png"),"shotgun":load("res://assets/gun_placeholder_3.png")}
func _ready():
	text_timer.one_shot = true
	get_tree().get_root().call_deferred("add_child", text_timer) #???
	get_parent().connect("pause",self,"_on_pause")

func set_ammo():
	$MagBar.max_value = float(current_weapon.get("mag_size"))
	$MagBar.value = float(current_weapon.get("current_mag"))
	$AmmoBar.max_value = float(current_weapon.get("reserve_ammo"))
	$AmmoBar.value = float(current_weapon.get("current_ammo"))

func set_icon():
	$WeaponIcon.texture = weapon_icons[current_weapon.get("classname")]
	$WeaponLabel.text = current_weapon.get("classname")
	
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
	text_tick()
	get_vals_tick()
	hud_ability_tick()
	if current_weapon == null:
		return
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

func get_vals_tick():
	var player = get_parent()
	set_health(player.get("health"))
	set_speed(player.get("velocity").x)
	set_firearm(get_node("../CarriedItem").get_children()[0]) # do this on event not every frame
	set_consts(player.get("consts"))
	set_ammo() # ditto
	set_icon()
	set_debug(player.get("debug_text"))

func _on_pause():
	$PauseMenu.show()
	get_tree().paused = true
	
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

func set_text(text,time):
	$TextBox.text = text
	$TextBox.visible_characters = 0
	text_timer.wait_time = float(time)/float(len(text))
	text_timer.start()
	
func text_tick():
	if text_timer.is_stopped():
		if abs($TextBox.visible_characters) < len($TextBox.text):
			$TextBox.visible_characters += 1
			text_timer.start()
