extends KinematicBody2D
class_name Bullet
const dt_name = "Bullet"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var damage
signal hit(damage)
onready var speed
var parent_id

# Called when the node enters the scene tree for the first time.
func init(_speed, _direction, _location, pangle, _damage,inst_id):
	speed = _speed
	parent_id = inst_id
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
		if collision.collider.get_instance_id() == parent_id:
			return
		if collision.collider.get_class() == "DTSurface":
			queue_free()
		elif collision.collider.get_class() == "KinematicBody2D":
			connect("hit",collision.collider,"on_hit")
			emit_signal("hit",damage)
			queue_free()
		elif collision.collider.get_class() == "StaticBody2D":
			connect("hit",collision.collider,"on_hit")
			emit_signal("hit",damage)
			queue_free()
		print(collision.collider.get_class())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
