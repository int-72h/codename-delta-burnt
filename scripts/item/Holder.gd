extends Node2D

# whole thing is very janky to begin with, weapon choice is fixed
onready var wepscenes = [preload("res://1911.tscn").instance(), preload("res://SSG.tscn").instance()]
var weapon = 0
var last_weapon = 0
signal wep_switch
signal wep_fire(entropy)
func _unhandled_key_input(event):
	print_stray_nodes()
	last_weapon = weapon
	if event.is_action_pressed("1", true):
		weapon = 0
	elif event.is_action_pressed("2", true):
		weapon = 1
	if last_weapon == weapon:
		return
	emit_signal("wep_switch")
	hidewep(wepscenes[last_weapon])
	showwep(wepscenes[weapon])


func hidewep(node):
	remove_child(node)

func showwep(node):
	add_child(node)

func _process(delta):
	if wepscenes[weapon].get("current_state") == 1:
		emit_signal("wep_fire",wepscenes[weapon].get("entropy"))
# Called when the node enters the scene tree for the first time.
func _ready():
	showwep(wepscenes[0])
	pass
