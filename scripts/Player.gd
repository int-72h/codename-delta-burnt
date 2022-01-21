extends Movable



onready var debugtext = get_node("../DebugLabel")
var up_ray
var down_ray
var left_ray
var right_ray
var facing = float()
##const resolve = {dir.up:"UpRay",dir.down:"DownRay",dir.right:"RightRay", dir.left:"RightRay"}
##var currently_colliding = {dir.up:Object(),dir.down:Object(),dir.right:Object(),dir.left:Object()}

func PointTowardsMouse():
	var mousepos = get_global_mouse_position()
	facing = atan((mousepos.y - position.y)/(mousepos.x-position.x))
	
func RayHandlingTick():
	if down_ray.is_colliding():
		location = contact_surface.ground
		jumps=0
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
	
# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	if event.is_action_pressed("ui_left",true):
		dir_x = x.left
		state = movement_state.run
	elif event.is_action_pressed("ui_right",true):
		dir_x = x.right
		state = movement_state.run
	elif event.is_action_pressed("ui_select"):
		dir_y = y.up
		state = movement_state.jump
	elif ((dir_x==x.left and event.is_action_released("ui_left") or (dir_x==x.right and event.is_action_released("ui_right")))):
		dir_x = x.none
		state = movement_state.idle

func _init():
	._init(1,500)

func _ready():
	up_ray = get_node("UpRay")
	down_ray = get_node("DownRay")
	left_ray = get_node("LeftRay")
	right_ray = get_node("RightRay")
	down_ray = get_node("DownRay")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	PointTowardsMouse()
	RayHandlingTick()
	move_and_slide(velocity)
	MovementTick()
	FrictionTick(delta)
	GravityTick(delta)
	debugtext.text = "PLAYER:\nVX= %s\nVY= %s\nSTATE= %s\nDIRX= %s\nDIRY= %s\nFACING= %s\nLOC:%s" % [velocity.x,velocity.y,movement_state.keys()[state],x.keys()[dir_x],y.keys()[dir_y],rad2deg(facing),contact_surface.keys()[location]]
	
