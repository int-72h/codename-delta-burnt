extends DTMovable
class_name DTEnemy
const dt_name = "DTEnemy"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal die
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
	$Node2D/AnimatedSprite.set("parent_id",get_instance_id())

func think():
	dist_to_player = player.get("global_position").distance_to(self.global_position)
	if (think_state == think.engaging) and abs(dist_to_player) <= abs(targ_dist):
		velocity.x = 0
		at_dist = true
	elif think_state == think.retreating and abs(dist_to_player) >= abs(targ_dist):
		velocity.x = 0
		at_dist = true
	if dist_to_player < 300 and think_state == think.idle: # spotted!
		think_state = think.engaging
		dist_set = false
		at_dist = false
	if at_dist and think_state == think.engaging:
		if hurt_state == hurt.no:
			$Node2D/AnimatedSprite.call("fire",get_angle_to(player.get("global_position")),true) # ugly firing code. change
	elif dist_to_player > 500 or (hurt_state == hurt.yes and think_state == think.retreating and at_dist == true and dist_set == true): # lost em, or we're not wussing
		hurt_state = hurt.no
		think_state = think.idle
		targ_dist = 100000
		velocity.x = 0
		at_dist = true
		dist_set = true
	if hurt_state == hurt.yes and think_state != think.retreating: # ow ow ow
		think_state = think.retreating # do more stuff
		dist_set = false
		at_dist = false
	if think_state == think.engaging: # set it.. ONCE
		if not dist_set and not at_dist:
			velocity.x = (dist_to_player/abs(dist_to_player)) * 100
			targ_dist = dist_to_player - 100
			dist_set = true
	elif think_state == think.retreating: # ditto
		if not dist_set and not at_dist:
			velocity.x = -(dist_to_player/abs(dist_to_player)) * 100
			targ_dist = dist_to_player + 300
			dist_set = true
	$Node2D/AnimatedSprite.call("reload")

func _physics_process(delta):
	RayHandlingTick()
	move_and_slide(velocity)
	MovementTick()
	GravityTick(delta)
	think()
	print_debug_enemy()

func on_hit(dmg):
	health = health - dmg
	print("ow")
	print(health)
	hurt_state = hurt.yes
	emit_signal("hurt",dmg)

func _process(delta):
	if health <= 0:
		emit_signal("die")
		queue_free()
	
func print_debug_enemy():
	$Label.text = "FIRING:%s\nTHINK:%s\nHURT:%s\nTARG:%s\nSET:%s\nAT:%s\nDIST2P:%s" % [firing_state,think_state,hurt_state,targ_dist,dist_set,at_dist,dist_to_player]

#TODO: Write enemy AI
#...easier said than done, to be fair
#convert to tilemaps!!!
