extends KinematicBody2D
class_name Bullet
const dt_name = "Bullet"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var damage
signal hit(object)
onready var speed


# Called when the node enters the scene tree for the first time.
func init(_speed, _direction, _location, pangle, _damage):
	speed = _speed
	damage = _damage
	self.global_position = _location
	rotate(_direction)
	if pangle:
		velocity.x = speed
	else:
		velocity.x = -speed
	velocity = velocity.rotated(_direction)


func _ready():
	pass


func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider.name == "DTSurface":  # collision issues stem here probably
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
