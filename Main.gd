extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD.set_health($Player.get("health"))
	$HUD.set_speed($Player.get("velocity").x)
	$HUD.set_firearm($Player/CarriedItem.get_children()[0]) # do this on event not every frame
	$HUD.set_entropy($Player.get("consts")[0])
	$HUD.set_ammo() # ditto
	$HUD.set_debug($Player.get("debug_text"))

