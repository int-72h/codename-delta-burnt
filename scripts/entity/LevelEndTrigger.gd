extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var collision = get_overlapping_bodies()
	if collision != []:
		print(collision)
		var _z = get_tree().change_scene("res://Scenes/Level2.tscn")
