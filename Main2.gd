extends Node2D
const enemy_scene = preload("res://Scenes/Enemy.tscn")
const enemy_spawn_array = [[enemy_scene,Vector2(128,192)],[enemy_scene,Vector2(100,200)]] # [[scene,positioning]...]
var enemies = []
func _process(delta):
	pass

func _ready():
	$Player/Abilities.call("init",[0,1])
	for x in enemy_spawn_array:
		var z = x[0].instance()
		z.set("global_position",x[1])
		z.connect("hurt", get_node("/root/root/Player"), "_on_Enemy_hurt")
		#z.connect("hurt", z, "on_hit")
		get_node("/root/root").add_child(z)
		enemies.append(z)
	$Player/HUD.call("set_sub_title","T+1:01:00:",Vector2(440,72))
	yield(get_tree().create_timer(1.0), "timeout")
	$Player/HUD.call("set_main_title","Dreams Never End",Vector2(300,90))
	yield(get_tree().create_timer(4.0), "timeout")
	$Player/HUD.call("set_text","Wow, now that's what I call a second level!")
