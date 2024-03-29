extends DTMovable
class_name DTEnemy
const dt_name = "DTEnemy"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal die
signal fire
signal reload
signal hurt(x)
enum firing{ no,yes}
enum think {idle, engaging, retreating}
enum hurt{no,yes}
var think_state = think.idle
var firing_state = firing.no
var hurt_state = hurt.no
var dist_set = true
var at_dist = true
var targ_dist = 10000000
var dist_to_player = 0
onready var player = get_node("/root/root/Player")
func _ready():
	._init()
	$Node2D.switch_weps(1)
	run_velocity = 100

func Think():
	if !is_instance_valid(player):
		return
	dist_to_player = player.get("global_position").distance_to(self.global_position)
	if (think_state == think.engaging) and abs(dist_to_player) <= abs(targ_dist):
		state = movement_state.idle
		dir_x = x.none
		at_dist = true
	elif think_state == think.retreating and abs(dist_to_player) >= abs(targ_dist):
		state = movement_state.idle
		dir_x = x.none
		at_dist = true
	if dist_to_player < 300 and think_state == think.idle: # spotted!
		think_state = think.engaging
		dist_set = false
		at_dist = false
	if at_dist and think_state == think.engaging:
		if hurt_state == hurt.no:
			emit_signal("fire")# ugly firing code. change
	elif dist_to_player > 300 or (hurt_state == hurt.yes and think_state == think.retreating and at_dist == true and dist_set == true): # lost em, or we're not wussing
		hurt_state = hurt.no
		think_state = think.idle
		targ_dist = 100000
		state = movement_state.idle
		dir_x = x.none
		at_dist = true
		dist_set = true
	if hurt_state == hurt.yes and think_state != think.retreating: # ow ow ow
		think_state = think.retreating # do more stuff
		dist_set = false
		at_dist = false
	if think_state == think.engaging: # set it.. ONCE
		if not dist_set and not at_dist:
			state = movement_state.run
			if (dist_to_player/abs(dist_to_player))>0:
				dir_x = x.right
			else:
				dir_x = x.left
			targ_dist = dist_to_player - 100
			dist_set = true
	elif think_state == think.retreating: # ditto
		if not dist_set and not at_dist:
			if (dist_to_player/abs(dist_to_player))>0:
				dir_x = x.left
			else:
				dir_x = x.right
			targ_dist = dist_to_player + 300
			dist_set = true
	emit_signal("reload")

func _physics_process(delta):
	CollisionTick()
	move_and_slide(velocity)
	MovementTick()
	FrictionTick(delta)
	GravityTick(delta)
	Think()
	print_debug_enemy()

func on_hit(dmg):
	health = health - dmg
	print("ow")
	print(health)
	hurt_state = hurt.yes
	emit_signal("hurt",dmg)

func _process(_delta):
	if health <= 0:
		emit_signal("die")
		queue_free()
	

func print_debug_enemy():
	$Label.text = "FIRING:%s\nTHINK:%s\nHURT:%s\nTARG:%s\nSET:%s\nAT:%s\nDIST2P:%s\nVEL:%s" % [firing_state,think_state,hurt_state,targ_dist,dist_set,at_dist,dist_to_player,velocity]

#TODO: Write enemy AI
#...easier said than done, to be fair
#convert to tilemaps!!!
