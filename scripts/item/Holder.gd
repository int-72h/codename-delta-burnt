extends Node2D

# whole thing is very janky to begin with
onready var wepscenes = [preload("res://Scenes/Empty.tscn").instance(),preload("res://Scenes/1911.tscn").instance(), preload("res://Scenes/SSG.tscn").instance()]
var weapon = 0
var last_weapon = 0
var weapons_enabled = [true,false,false] # change to bitwise later
signal wep_switch(weapon_id)
signal wep_fire(entropy)

func _unhandled_key_input(event):
	last_weapon = weapon
	if event.is_action_pressed("1", true) and weapons_enabled[1] == true:
		weapon = 1
	elif event.is_action_pressed("2", true) and weapons_enabled[2] == true:
		weapon = 2
	if last_weapon == weapon:
		return
	switch_weps(weapon)

func switch_weps(to):
	if last_weapon != 0:
		remove_child(wepscenes[last_weapon])
	add_child(wepscenes[to])
	weapon = to
	emit_signal("wep_switch",to)


func _process(_delta):
	if wepscenes[weapon].get("current_state") == 1:
		emit_signal("wep_fire",wepscenes[weapon].get("entropy"),wepscenes[weapon].get("recoil"))
# Called when the node enters the scene tree for the first time.

func _ready():
	connect("wep_switch",get_node("/root/root/Player/HUD"),"_on_wep_switch")
	switch_weps(0)
	pass
