extends Node2D
class_name ability
signal ability_start(id)
signal ability_stop(id)
signal ability_ready(id)
signal ability_not_ready(id)
enum state{not_ready,ready,active,cooldown}
const func_array = [["speed_up_00_start","speed_up_00_tick"],["add_dmg_01_start","add_dmg_01_tick"],["time_jump_down_02_start","time_jump_down_02_tick"],["time_jump_up_03_start","time_jump_up_03_tick"],]
var ability_keys = ["ui_page_up","ui_page_down","ui_x","ui_y"]
var ability_timers = []
var ability_states = [state.ready,state.ready,state.ready,state.ready]
var ability_array = []
onready var player = get_node("/root/root/Player")
onready var consts = get_node("/root/root/Player").get("consts")


func init(_ability_array):
	ability_array = _ability_array
	for _x in range(0,len(ability_array)):
		var timer = Timer.new()
		timer.one_shot = true
		player.call_deferred("add_child", timer)
		ability_timers.append(timer)

func speed_up_00_start(x):
	var timer = ability_timers[x]
	if ability_states[x] == state.ready:
		player.set("run_velocity",player.get("run_velocity") + 200) # set the thing itself
		timer.wait_time = 5
		timer.start() # set and start the timer...
		print("started!")
		ability_states[x] = state.active # mark in the ability states that it's active
		emit_signal("ability_start",0) # emit a signal that we've started it
	
func speed_up_00_tick(x):
	var timer = ability_timers[x] # get the timer
	if timer.is_stopped(): 
		if ability_states[x] == state.active:
			player.set("run_velocity",player.get("run_velocity") - 100)
			timer.wait_time = 10
			timer.start() # if it's running, unset the ability and set a cooldown
			ability_states[x] = state.cooldown
			emit_signal("ability_stop",0) 
		elif consts[0] > 100:
			emit_signal("ability_ready",0) # condition activated, mark as ready
			ability_states[x] = state.ready
		else:
			emit_signal("ability_not_ready",0)
			ability_states[x] = state.not_ready

func add_dmg_01_start(x):
	var timer = ability_timers[x]
	if ability_states[x] == state.ready:
		var weapon = get_node("/root/root/Player/CarriedItem").get_children()[0]
		weapon.set("damage",weapon.get("damage")*1.2)
		timer.wait_time = 5
		timer.start()
		print("started!")
		ability_states[x] = state.active
		emit_signal("ability_start",1)
	
func add_dmg_01_tick(x):
	var timer = ability_timers[x]
	if timer.is_stopped():
		if ability_states[x] == state.active:
			var weapon = get_node("/root/root/Player/CarriedItem").get_children()[0]
			weapon.set("damage",weapon.get("damage")/1.2)
			timer.wait_time = 10
			timer.start()
			ability_states[x] = state.cooldown
			emit_signal("ability_stop",1)
		elif consts[1] > 5:
			emit_signal("ability_ready",1)
			ability_states[x] = state.ready
		else:
			emit_signal("ability_not_ready",1)
			ability_states[x] = state.not_ready

func time_jump_down_02_start(x,y=-1):
	var timer = ability_timers[x]
	if ability_states[x] == state.ready:
		var ctime = player.get("current_time")
		if ctime != y:
			player.call("time_jump",("down" if y==-1 else "up"))
			timer.wait_time = 0.1
			timer.start()
			ability_states[x] = state.active
			emit_signal("ability_start",(2 if y==-1 else 3))
			
func time_jump_down_02_tick(x,y=false): # all we do is stop the timer since it's a single action
	var timer = ability_timers[x]
	if timer.is_stopped():
		if ability_states[x] == state.active:
			timer.wait_time = 10
			timer.start()
			ability_states[x] = state.cooldown
			emit_signal("ability_stop",(3 if y else 2))
		else:
			emit_signal("ability_ready",(3 if y else 2))
			ability_states[x] = state.ready

func time_jump_up_03_start(x):
	time_jump_down_02_start(x,1)


func time_jump_up_03_tick(x):
	time_jump_down_02_tick(x,true)
	
func AbilityTick():
	for x in range(0,len(ability_array)):
		call(func_array[ability_array[x]][1],x)

func InputCheck(event):
	for x in range(0,len(ability_array)):
		if event.is_action_pressed(ability_keys[x]):
			call(func_array[ability_array[x]][0],x)
