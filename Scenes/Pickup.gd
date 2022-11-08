extends Area2D

export var pickup_id = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.frame = pickup_id
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(_delta):
	var collision = get_overlapping_bodies()
	if collision != []:
		print(collision)
		get_node("/root/root/SFX").stream = preload("res://assets/clink.wav")
		get_node("/root/root/SFX").play()
		get_node("/root/root/Player").call("pickup_item",pickup_id)
		queue_free()
