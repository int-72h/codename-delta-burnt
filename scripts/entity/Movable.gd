extends KinematicBody2D
class_name DTMovable

const terminal_velocity = 2200.0

enum x { none, left, right }
enum y { none, up, down }
enum contact_surface { none, ground, wall, roof }
enum movement_state { idle, run, jump, dash }

var location = contact_surface.ground
var dir_x = x.none
var dir_y = y.none
var state = movement_state.idle
var currently_colliding = {x.left: Object(), x.right: Object(), y.up: Object(), y.down: Object()}
var gravity = 500
var run_velocity = 2250
var jump_velocity = 150
var dash_velocity = 800
var velocity = Vector2()
var health
var rep = false
var jumps = 0
var current_time = 0
var time_area_offset = 1000
var max_jumps

func CollisionTick():
	var left_bound = global_position.x
	var right_bound = $CollisionShape2D.shape.extents.x
	if is_on_floor():
		location = contact_surface.ground
		jumps = 0
		currently_colliding[y.down] = get_slide_collision(0).collider
	elif is_on_ceiling():
		location = contact_surface.roof
		velocity.y = 0
		currently_colliding[y.up] = get_slide_collision(0).collider
	elif is_on_wall() and get_slide_collision(0).collider:
		var z = get_slide_collision(0).collider
		if z.global_position.x <= left_bound:
				location = contact_surface.wall
				currently_colliding[x.left] = z
		elif z.global_position.x >= right_bound:
				location = contact_surface.wall
				currently_colliding[x.right] = z
	else:
		location = contact_surface.none
	


func FrictionTick(_delta):
	if dir_x == x.none and (location != contact_surface.none):
		var obj = currently_colliding[y.down]
		if obj != null:
			if obj.call("get_class") == "DTSurface":
				velocity.x = currently_colliding[y.down].mu * velocity.x


func GravityTick(delta):
	if location != contact_surface.ground:
		velocity.y += gravity * delta
	elif velocity.y > 0:
		velocity.y = 0
	if abs(velocity.y) > terminal_velocity:
		velocity.y = terminal_velocity * sign(velocity.y)


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
	
func _init(_maxjumps = 1, _gravity = 500, _run_velocity = 200, _health=100):
	max_jumps = _maxjumps
	gravity = _gravity
	run_velocity = _run_velocity
	health = _health


### FORCES TESTING ###
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
