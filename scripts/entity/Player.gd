extends DTMovable
class_name DTPlayer

onready var debugtext = get_node("../DebugLabel")
var pangle = true
var facing = float()
var debug_text = ""
var consts = [0.0,0.0,0] # entropy,juice,?
onready var Abilities = $Abilities
signal fire(direction, location)
signal die(health, location)
signal pause
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
	elif event.is_action_pressed("ui_esc",true):
		emit_signal("pause")
	Abilities.InputCheck(event)


func _ready():
	._init(1, 500,200)

func _physics_process(delta):
	PointTowardsMouse()
	RayHandlingTick()
	move_and_slide(velocity)
	MovementTick()
	FrictionTick(delta)
	GravityTick(delta)
	EntropyTick(delta)
	JuiceTick(delta)
	HeatTick(delta)
	Abilities.AbilityTick()
	debug_text = "VX=%s\nVY=%s\nSTATE=%s\nDIRX=%s\nDIRY=%s\nFACING=%s\nLOC:%s\nPANGLE:%s\nENTROPY:%s\nRUNVEL:%s\nTIMER:%s\nJUICE:%s\nWEIRD:%s" % [velocity.x, velocity.y, movement_state.keys()[state], x.keys()[dir_x], y.keys()[dir_y], facing, contact_surface.keys()[location], pangle,consts[0],run_velocity,Abilities.ability_timers[0].time_left,consts[1],consts[2]]


func _on_Enemy_hurt(x):
	consts[1] += x

func _on_CarriedItem_wep_switch():
	pass

func _on_CarriedItem_wep_fire(entropy):
	consts[0] += entropy

func on_hit(damage):
	health = health - damage
	emit_signal("hurt",damage)
	
func EntropyTick(delta):
	consts[0] -= consts[0] * delta

func JuiceTick(delta):
	consts[1] -= consts[1] * delta 

func HeatTick(delta):
	if consts[0] > 500:
		consts[2] += consts[0] - 500
		consts[0] = 500
	if consts[1] > 50:
		consts[2] += consts[1] - 50
		consts[1] = 50
	consts[2] -= consts[2] * delta 

#func CollisionCheck():
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.get("dt_name") == "Bullet":
#			health = health - collision.collider.damage
#			print("ow")
#			print(health)
#			emit_signal("hurt",collision.collider.damage)
#			collision.collider.queue_free()
