extends DTMovable
class_name DTPlayer

onready var debugtext = get_node("../DebugLabel")
var pangle = true
var facing = float()
var debug_text
var consts = [0.0,0.0,0.0] # entropy, ?,?
var ability_matrix = ["speed_up_00"]
var ability_timers=[]
var ability_keys = ["ui_page_up"]
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
	elif event.is_action_pressed("ui_home",true):
		health -= 1
	elif dir_x == x.left and event.is_action_released("ui_left") or (dir_x == x.right and event.is_action_released("ui_right")):
		dir_x = x.none
		state = movement_state.idle
	for x in range(0,len(ability_matrix)):
		if event.is_action_pressed(ability_keys[x]):
			call(ability_matrix[x] + "_start")


func _ready():
	._init(1, 500,200)
	for x in range(0,len(ability_matrix)):
		var timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		ability_timers.append(timer)
		

func _physics_process(delta):
	PointTowardsMouse()
	RayHandlingTick()
	move_and_slide(velocity)
	MovementTick()
	FrictionTick(delta)
	GravityTick(delta)
	EntropyTick(delta)
	AbilityTick()
	debug_text = "VX=%s\nVY=%s\nSTATE=%s\nDIRX=%s\nDIRY=%s\nFACING=%s\nLOC:%s\nPANGLE:%s\nENTROPY:%s\nRUNVEL:%s\nTIMER:%s" % [velocity.x, velocity.y, movement_state.keys()[state], x.keys()[dir_x], y.keys()[dir_y], facing, contact_surface.keys()[location], pangle,consts[0],run_velocity,ability_timers[0].time_left]


func speed_up_00_start():
	print(ability_timers[0].wait_time)
	if consts[0] > 1000 and (ability_timers[0].is_stopped() and ability_timers[0].wait_time != 5):
		run_velocity += 100
		ability_timers[0].wait_time = 5
		ability_timers[0].start()
		print("started!")
func speed_up_00_done():
	if ability_timers[0].is_stopped() and ability_timers[0].wait_time == 5:
		run_velocity -= 100
		ability_timers[0].wait_time = 10
		ability_timers[0].start()
		while ability_timers[0].is_stopped():
			ability_timers[0].start()
		print("cooldown!")
func _on_CarriedItem_wep_switch():
	pass # Replace with function body.


func _on_CarriedItem_wep_fire(entropy):
	consts[0] += entropy

func EntropyTick(delta):
	consts[0] -= consts[0] * delta

func AbilityTick():
	for x in range(0,len(ability_matrix)):
		call(ability_matrix[x] + "_done")
