extends KinematicBody2D


const gravity = 500
onready var debugtext = get_node("../DebugLabel")
var velocity = Vector2()
enum dir{none=0,up=4,down=4,left=-1,right=1}
enum loc{air,ground,wall,roof}
var location = loc.ground
var pressed = Vector2(0,0)
var facing = float()
const resolve = {dir.up:"UpRay",dir.down:"DownRay",dir.right:"RightRay", dir.left:"RightRay"}
var currently_colliding = {dir.up:Object(),dir.down:Object(),dir.right:Object(),dir.left:Object()}

func PointTowardsMouse():
	var mousepos = get_global_mouse_position()
	facing = atan((mousepos.y - position.y)/(mousepos.x-position.x))
	
func RayHandlingTick():
	for dir in resolve:
		currently_colliding[dir] = get_node(resolve[dir]).get_collider()
	if currently_colliding[dir.down] != null:
		location = loc.ground
	elif currently_colliding[dir.left] != null or (currently_colliding[dir.right] != null):
		location = loc.wall
	elif currently_colliding[dir.up]:
		location = loc.roof
	else:
		location = loc.air
	
	
func FrictionTick():
	if location == loc.ground:
		var obj = currently_colliding[dir.down]
		if obj.call("get_class") == "DTSurface":
			velocity.x = currently_colliding[dir.down].mu * velocity.x
			
		print(obj.call("get_class"))
			
		
func GravityTick(delta):
	if location != loc.ground:
		velocity.y += gravity * delta
	
func MovementTick():
	velocity.x = 100 * pressed.x
	if pressed.y == dir.up:
		velocity.x = 50
	
# Called when the node enters the scene tree for the first time.
func _unhandled_input(event): # use a dict to match these
	if event.is_action_pressed("ui_left"):
		pressed.x = dir.left
	elif event.is_action_pressed("ui_right"):
		pressed.x = dir.right
	if event.is_action_pressed("ui_down"):
		pressed.y = dir.down
	elif event.is_action_pressed("ui_accept"):
		pressed.y = dir.up
	else:
		pressed = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	PointTowardsMouse()
	RayHandlingTick()
	MovementTick()
	FrictionTick()
	GravityTick(delta)
	move_and_slide(velocity)
	debugtext.text = "PLAYER:\nVX= %s\nVY= %s\nPRESSEDX= %s\nPRESSEDY= %s\nLOCATION= %s\nFACING= %s\n" % [velocity.x,velocity.y,dir.keys()[pressed.x],dir.keys()[pressed.y],loc.keys()[location],rad2deg(facing)]
	
