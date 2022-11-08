extends Node2D
const enemy_scene = preload("res://Scenes/Enemy.tscn")
const enemy_spawn_array = [[enemy_scene,Vector2(128,192)]] # [[scene,positioning]...]
var enemies = []

func _ready():
	$Player/Abilities.call("init",[0,1,2,3])
	for x in enemy_spawn_array:
		var z = x[0].instance()
		z.set("global_position",x[1])
		z.connect("hurt", get_node("/root/root/Player"), "_on_Enemy_hurt")
		#z.connect("hurt", z, "on_hit")
		get_node("/root/root").add_child(z)
		enemies.append(z)
	$Player/HUD.call("set_sub_title","T+1:00:00:",Vector2(440,72))
	yield(get_tree().create_timer(1.0), "timeout")
	$Player/HUD.call("set_main_title","Solid State Survivor",Vector2(300,90))
	yield(get_tree().create_timer(3.0), "timeout")
	yield($Player/HUD,"not_playing_text")
	yield(get_tree().create_timer(1.0), "timeout")
	$Player/HUD.call("set_text","Here's some very enthralling text indeed! Lorem ipsum and all that...")
	
