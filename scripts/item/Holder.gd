extends Node2D

# whole thing is very janky to begin with
onready var wepscenes = [preload("res://Scenes/Empty.tscn").instance(),preload("res://Scenes/1911.tscn").instance(), preload("res://Scenes/Shotgun.tscn").instance()]
var weapon = 0
var last_weapon = 0
signal wep_switch(weapon_id)
signal wep_fire(entropy)


func switch_weps(to):
	if weapon == to:
		return
	last_weapon = weapon
	if last_weapon != 0:
		remove_child(wepscenes[last_weapon])
	add_child(wepscenes[to])
	weapon = to
	wepscenes[weapon].connect("wep_fire",get_parent(),"_on_wep_fire")
	get_parent().connect("fire",wepscenes[weapon],"fire")
	get_parent().connect("reload",wepscenes[weapon],"reload")
	emit_signal("wep_switch",to)

func get_current_weapon():
	return wepscenes[weapon]
func _process(_delta):
	pass
# Called when the node enters the scene tree for the first time.

func _ready():
	switch_weps(0)
	pass
