extends DTMovable
class_name DTPlayer

onready var debugtext = get_node("../DebugLabel")
var pangle = true
var facing = float()

signal fire(direction, location)
signal die(health, location)
signal reload


func PointTowardsMouse():
	var mousepos = get_global_mouse_position()
	facing = get_angle_to(mousepos)
	var pos = self.global_position
	if (mousepos.x > pos.x && pangle == false) || (mousepos.x < pos.x && pangle == true):
		print(pos.x)
		print(mousepos.x)
		self.apply_scale(Vector2(-1, 1))
		pangle = !pangle


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event):
	if event.is_action_pressed("mouse1", true):
		emit_signal("fire", facing, pangle)
	if event.is_action_pressed("mouse2", true):
		emit_signal("reload")
	if event.is_action_pressed("ui_left", true):
		dir_x = x.left
		state = movement_state.run
	elif event.is_action_pressed("ui_right", true):
		dir_x = x.right
		state = movement_state.run
	elif event.is_action_pressed("ui_select"):
		dir_y = y.up
		state = movement_state.jump
	elif dir_x == x.left and event.is_action_released("ui_left") or (dir_x == x.right and event.is_action_released("ui_right")):
		dir_x = x.none
		state = movement_state.idle


func _ready():
	._init(1, 500)


func _physics_process(delta):
	PointTowardsMouse()
	RayHandlingTick()
	move_and_slide(velocity)
	MovementTick()
	FrictionTick(delta)
	GravityTick(delta)
	debugtext.text = "PLAYER:\nVX= %s\nVY= %s\nSTATE= %s\nDIRX= %s\nDIRY= %s\nFACING= %s\nLOC:%s\nPANGLE:%s\n" % [velocity.x, velocity.y, movement_state.keys()[state], x.keys()[dir_x], y.keys()[dir_y], facing, contact_surface.keys()[location], pangle]
