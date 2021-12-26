extends KinematicBody2D

const gravity = -500
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func DoGravityTick(delta):
	velocity.y += gravity * delta
	
func DoMovementTick():
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
