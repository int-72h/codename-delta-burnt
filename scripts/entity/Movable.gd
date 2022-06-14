extends KinematicBody2D
class_name DTMovable

const terminal_velocity = 2200.0

enum x { none, left, right }
enum y { none, up, down }
enum contact_surface { none, ground, wall, roof }
enum movement_state { idle, run, jump }

var location = contact_surface.ground
var dir_x = x.none
var dir_y = y.none
var state = movement_state.idle
var currently_colliding = {x.left: Object(), x.right: Object(), y.up: Object(), y.down: Object()}
var gravity = 500
var run_velocity = 200
var jump_velocity = 100
var velocity = Vector2()
var fvelocity = Vector2()
var rep = false
var jumps = 0
var max_jumps
var up_ray
var down_ray
var left_ray
var right_ray


func RayHandlingTick():
	if down_ray.is_colliding():
		location = contact_surface.ground
		jumps = 0
		currently_colliding[y.down] = down_ray.get_collider()
	elif up_ray.is_colliding():
		location = contact_surface.roof
		currently_colliding[y.up] = up_ray.get_collider()
	elif left_ray.is_colliding():
		location = contact_surface.wall
		currently_colliding[x.left] = left_ray.get_collider()
	elif right_ray.is_colliding():
		location = contact_surface.wall
		currently_colliding[x.right] = right_ray.get_collider()
	else:
		location = contact_surface.none


func FrictionTick(delta):
	if dir_x == x.none and (location != contact_surface.none):
		var obj = currently_colliding[y.down]
		if obj.call("get_class") == "DTSurface":
			velocity.x = currently_colliding[y.down].mu * velocity.x


func GravityTick(delta):
	if location != contact_surface.ground:
		velocity.y += gravity * delta
	elif velocity.y > 0:
		velocity.y = 0


func MovementTick():
	if state == movement_state.run:
		if dir_x == x.left:
			velocity.x = -run_velocity
		elif dir_x == x.right:
			velocity.x = run_velocity
	elif dir_y == y.up and jumps != max_jumps:
		velocity.y = -jump_velocity
		dir_y = y.none
		jumps += 1


func _init(_maxjumps = 1, _gravity = 500, _run_velocity = 200):
	max_jumps = _maxjumps
	gravity = _gravity
	run_velocity = _run_velocity
	up_ray = get_node("UpRay")
	down_ray = get_node("DownRay")
	left_ray = get_node("LeftRay")
	right_ray = get_node("RightRay")
	down_ray = get_node("DownRay")


### FORCES TESTING ###
var fg = 981
var run_force = 8000
var mass = 1
var jump_force = 100000
var force = Vector2()

#func fFrictionTick():
#	if dir_x == x.none and (location != contact_surface.none):
#		var obj = currently_colliding[y.down]
#		if obj.call("get_class") == "DTSurface":
#			force.x = currently_colliding[y.down].mu * mass * force.x # jank!
#
#func fGravityTick():
#	if location != contact_surface.ground:
#		force.y += mass * fg # force = mass x acceleration
#	elif velocity.y > 0:
#		force.y == 0
#
#func fMovementTick(delta):
#	if state == movement_state.run and rep == false:
#		if dir_x == x.left:
#			force.x += (mass * -run_force)
#		elif dir_x == x.right:
#			force.x += (mass * run_force)
#		rep = true
#	elif dir_y == y.up and jumps != max_jumps and rep == false:
#		force.y += (-jump_force * mass)
#		dir_y = y.none
#		jumps+=1
#		rep = true
#	elif state == movement_state.idle:
#		rep = false
#
#
#func fApplyForces(delta): # f = ma
#	var acc = (force)/mass
#	fvelocity = acc * delta
