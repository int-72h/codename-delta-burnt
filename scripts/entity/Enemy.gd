extends DTMovable
class_name DTEnemy
const dt_name = "DTEnemy"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal die
signal hurt(x)
onready var player = get_node("/root/root/Player")
func _ready():
	._init()
	$Node2D/AnimatedSprite.set("parent_id",get_instance_id())

func think():
	var dist_to_player = player.get("global_position").distance_to(self.global_position)
	if dist_to_player < 300:
		$Node2D/AnimatedSprite.call("fire",get_angle_to(player.get("global_position")),true)
	$Node2D/AnimatedSprite.call("reload")

func _physics_process(delta):
	RayHandlingTick()
	move_and_slide(velocity)
	MovementTick()
	GravityTick(delta)
	think()

func on_hit(dmg):
	health = health - dmg
	print("ow")
	print(health)
	emit_signal("hurt",dmg)

func _process(delta):
	if health <= 0:
		emit_signal("die")
		queue_free()
	


#TODO: Write enemy AI
#...easier said than done, to be fair
#convert to tilemaps!!!
