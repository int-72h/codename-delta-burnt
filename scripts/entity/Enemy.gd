extends DTMovable
class_name DTEnemy

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 50
signal die
# Called when the node enters the scene tree for the first time.
func _ready():
	._init()

func _physics_process(delta):
	RayHandlingTick()
	move_and_slide(velocity)
	MovementTick()
	GravityTick(delta)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Bullet": # also doesn't work. check
				health = health - collision.collider.damage
				print("ow")
				print(health)
				collision.collider.queue_free()

func _process(delta):
	if health <= 0:
		emit_signal("die")
		queue_free()

#TODO: Write enemy AI
#...easier said than done, to be fair
