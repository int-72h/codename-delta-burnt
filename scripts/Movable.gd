extends KinematicBody2D

class_name Movable
const terminal_velocity: float = 2200.0	
var gravity = 500
var run_velocity = 200
var max_jumps
var velocity = Vector2()
enum x{none,left,right}
enum y{none,up,down}
enum contact_surface{none,ground,wall,roof}
enum movement_state{idle,run,jump}
var location = contact_surface.ground
var dir_x = x.none
var dir_y = y.none
var state = movement_state.idle
var jumps = 0
var currently_colliding = {x.left:Object(),x.right:Object(),y.up:Object(),y.down:Object()}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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
			velocity.x = -200
		elif dir_x == x.right:
			velocity.x = 200
	elif dir_y == y.up and jumps != max_jumps:
		velocity.y =+ -100
		dir_y = y.none
		jumps+=1
		

# Called when the node enters the scene tree for the first time.
func _init(_maxjumps=1,_gravity=500,run_velocity=200):
	max_jumps = _maxjumps
	gravity = _gravity
	run_velocity= run_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass