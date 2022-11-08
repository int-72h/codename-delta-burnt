extends Node2D

# whole thing is very janky to begin with, weapon choice is fixed
onready var wepscenes=[$AnimatedSprite,$AnimatedSprite2]
var weapon = 0
var last_weapon = 0
#signal wep_switch
#signal wep_fire(entropy)

func switch_weapons(to):
	last_weapon = weapon
	hidewep(wepscenes[last_weapon])
	showwep(wepscenes[to])

func hidewep(node):
	remove_child(node)

func showwep(node):
	add_child(node)

func _process(_delta):
	var player = get_node("/root/root/Player")
	if player != null:
		look_at(player.get("global_position"))
# Called when the node enters the scene tree for the first time.
func _ready():
	hidewep(wepscenes[0])
	hidewep(wepscenes[1])
	showwep(wepscenes[0])
	pass
