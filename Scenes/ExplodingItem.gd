extends KinematicBody2D
class_name DTExplodingItem
const terminal_velocity = 10

var gravity = 1
var velocity = Vector2()
var exploded

func GravityTick(delta):
	if exploded:
		velocity.y += gravity * delta
		if abs(velocity.y) > terminal_velocity:
			velocity.y = terminal_velocity * sign(velocity.y)



func _init(_gravity = 500):
	gravity = _gravity
	
func _physics_process(delta):
	GravityTick(delta)
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
	
	
func explode():
	velocity = Vector2(rand_range(0,50),rand_range(-10000000000,0))
	exploded = true
