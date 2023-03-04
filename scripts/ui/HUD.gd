extends CanvasLayer

var current_weapon
onready var player_node = get_node("/root/root/Player/Abilities")
var ability_active = [0,0,0,0] # inefficient
var good_face = load("res://assets/good_face_placeholder.png")
var med_face = load("res://assets/medium_face_placeholder.png")
var bad_face = load("res://assets/bad_face_placeholder.png")
onready var player = get_parent()
var currently_playing_text = false
signal not_playing_text
onready var text_timer = Timer.new()
onready var title_timer = Timer.new()
onready var weapon_icons = {"Empty":load("res://assets/logo.png"), "1911":load("res://assets/gun_placeholder_2.png"),"Shotgun":load("res://assets/gun_placeholder_3.png")}
onready var pickup_text = {0:"How do you pickup nothing?!",1:"Gotta love the 1911! 7 rounds 'ought to be enough for any genetically modified soldier.",2:"Somebody got lazy with texturing."}
func _ready():
	text_timer.one_shot = true
	title_timer.one_shot = true
	title_timer.wait_time = 0
	get_tree().get_root().call_deferred("add_child", text_timer) #???
	get_tree().get_root().call_deferred("add_child", title_timer)
	get_parent().connect("pause",self,"_on_pause")
	get_node("/root/root/Player/CarriedItem").connect("wep_switch",self,"_on_wep_switch")

func set_ammo():
	$MagBar.max_value = float(current_weapon.get("mag_size"))
	$MagBar.value = float(current_weapon.get("current_mag"))
	$AmmoBar.max_value = float(current_weapon.get("reserve_ammo"))
	$AmmoBar.value = float(current_weapon.get("current_ammo"))

func set_icon():
	$WeaponIcon.texture = weapon_icons[current_weapon.get("weapon_name")]
	$WeaponLabel.text = current_weapon.get("weapon_name")
	
func set_health(health):
	$HealthBar.value = float(health)
func set_speed(speed):
	$VBoxContainer/SpeedBar.value = abs(speed)
func set_firearm(firearm):
	current_weapon=firearm
	$ReloadBar.max_value = current_weapon.get("reload_time")
func set_consts(consts):
	for x in range(0,len(consts)):
		get_node("VBoxContainer/ConstBar"+str(x)).value = consts[x]
func _process(_delta):
	if current_weapon == null:
		return
	text_tick()
	#title_tick()
	get_vals_tick()
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
	if current_weapon.get("current_state") == 1 or current_weapon.get("current_state") ==  2:
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


func _on_wep_switch(id):
	set_firearm(get_node("../CarriedItem").get_current_weapon())
	if current_weapon != null:
		set_ammo()
		set_icon()

func get_vals_tick():
	set_ammo()
	set_health(player.get("health"))
	set_speed(player.get("velocity").x)
	set_debug(player.get("debug_text"))
	set_consts(player.get("consts"))

func _on_pause():
	$PauseMenu.show()
	get_tree().paused = true
	
func _on_Abilities_ability_ready(id): 
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(255,255,255))

func _on_Abilities_ability_start(id):
	print(id)
	ability_active[id] = 1
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(50,129,0))
	if id == 2 or id == 3:
		$tjump_image.show()
		$tjump_image.modulate = Color(1,1,1,1)
		var tween = get_tree().create_tween().set_parallel()
		tween.tween_property($tjump_image,"modulate",Color.transparent,1)
		yield(get_tree().create_timer(1.0), "timeout")
		$tjump_image.hide()

func _on_Abilities_ability_stop(id):
	ability_active[id] = 0
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(0,0,255))

func _on_Abilities_ability_not_ready(id):
	get_node("AbilityLabel" + str(id)).add_color_override("font_color", Color(0,0,0))

func set_text(text):
	$TextBox.text = text
	$TextBox.visible_characters = 0
	text_timer.wait_time = 0.1 # baked in, make constant or var possibly
	text_timer.start()
	currently_playing_text = true
	
func text_tick():
	if text_timer.is_stopped():
		if abs($TextBox.visible_characters) < len($TextBox.text):
			$TextBox.visible_characters += 1
			text_timer.start()
		else:
			currently_playing_text = false
			emit_signal("not_playing_text")
			
func set_main_title(text,to):
	$TitleText.visible = true
	$TitleText.text = text
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($TitleText,"modulate",Color.white,4)
	tween.tween_property($TitleText, "rect_position", to,4)
	#yield(get_tree().create_timer(4.0), "timeout")
	tween.chain().tween_property($TitleText,"modulate",Color.transparent,1).set_delay(2)
	#$TitleText.visible = false

func set_sub_title(text,to):
	$SubtitleText.visible = true
	$SubtitleText.text = text
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($SubtitleText,"modulate",Color.white,4)
	tween.tween_property($SubtitleText, "rect_position", to,4)
	#yield(get_tree().create_timer(4.0), "timeout")
	tween.chain().tween_property($SubtitleText,"modulate",Color.transparent,1).set_delay(2)
	#$TitleText.visible = false

func on_item_pickup(item_id):
	set_text(pickup_text[item_id])

