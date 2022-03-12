extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var wepscenes = [preload("res://1911.tscn").instance(),preload("res://SSG.tscn").instance()]
var weapon = 0
var last_weapon = 0
func _unhandled_key_input(event):
	print_stray_nodes()
	last_weapon = weapon
	if event.is_action_pressed("1",true):
		weapon = 0
	elif event.is_action_pressed("2",true):
		weapon = 1
	hidewep(wepscenes[last_weapon])
	showwep(wepscenes[weapon])
	
func hidewep(node):
	remove_child(node)
func showwep(node):
	add_child(node)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	showwep(wepscenes[0])
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
