extends DTMovable
class_name DTPlayer


var pangle = true
var facing = float()
var debug_text = ""
var consts = [0.0,0.0]
export var enabled_weapons = [true,true,true]
onready var Abilities = $Abilities
signal fire(direction, location)
signal die(health, location)
signal hurt(damage)
signal pause
signal reload

func PointTowardsMouse():
	var mousepos = get_global_mouse_position()
	facing = get_angle_to(mousepos)
	var pos = self.global_position
	if (mousepos.x > pos.x && pangle == false) || (mousepos.x < pos.x && pangle == true):
		print("flipping!")
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
	elif event.is_action_pressed("1", true) and enabled_weapons[1] == true:
		$CarriedItem.switch_weps(1)
	elif event.is_action_pressed("2", true) and enabled_weapons[2] == true:
		$CarriedItem.switch_weps(2)
	else:
		Abilities.InputCheck(event)

func _on_Enemy_hurt(x):
	consts[1] += x
	
	
func _on_wep_fire(recoil,entropy):
	consts[0] += entropy
	var angle = facing
	var y =  recoil * sin(facing) # angles are the same in the opposite direction, hsin(a) = o
	var x = recoil * cos(facing)
	if pangle:
		x = -x
		y = -y
	velocity.y += y*1.5
	velocity.x += x
	print("y: %s x: %s" % [y,x])

func on_hit(damage):
	health = health - damage
	emit_signal("hurt",damage)
	if health < 1:
		die()

func time_jump(direction):
	if direction:
		global_position.y += 8192
		get_node("/root/root/Camera2D").position.y += 8192
		dim = true
	else:
		global_position.y -= 8192
		dim = false
		get_node("/root/root/Camera2D").position.y -= 8192

func die():
	get_node("/root/root/SFX").stream = preload("res://assets/sfx_3.wav")
	get_node("/root/root/SFX").play()
	var explodescene = preload("res://Scenes/ExplodingPlayer.tscn").instance()
	get_node("/root/root").add_child(explodescene)
	explodescene.visible = true
	explodescene.global_position = global_position
	explodescene.explode()
	#yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
	
	
func EntropyTick(delta):
	consts[0] -= consts[0] * delta

func HeatTick(delta):
	consts[1] -= consts[1] * delta 

func pickup_item(item_id):
	enabled_weapons[item_id] = true
	$CarriedItem.call("switch_weps",item_id)
	$HUD.call("on_item_pickup",item_id)


func _ready():
	._init(1, 500,200)

func _physics_process(delta):
	PointTowardsMouse()
	#RayHandlingTick()
	CollisionTick()
	MovementTick()
	FrictionTick(delta)
	GravityTick(delta)
	EntropyTick(delta)
	HeatTick(delta)
	move_and_slide(velocity,Vector2(0,-1))
	Abilities.AbilityTick()
	if state == movement_state.run:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.play("idle")
		$AnimatedSprite.frame = 0
	debug_text = "VX=%s\nVY=%s\nSTATE=%s\nDIRX=%s\nDIRY=%s\nFACING=%s\nLOC:%s\nPANGLE:%s\nENTROPY:%s\nRUNVEL:%s\nTIMER:%s\nJUICE:%s" % [velocity.x, velocity.y, movement_state.keys()[state], x.keys()[dir_x], y.keys()[dir_y], facing, contact_surface.keys()[location], pangle,consts[0],run_velocity,Abilities.ability_timers[0].time_left,consts[1]]

#func CollisionCheck():
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.get("dt_name") == "Bullet":
#			health = health - collision.collider.damage
#			print("ow")
#			print(health)
#			emit_signal("hurt",collision.collider.damage)
#			collision.collider.queue_free()
