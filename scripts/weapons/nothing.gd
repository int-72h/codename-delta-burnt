extends DTFirearm
const classname = "Empty"
#fudgerama! the hud can't handle nothing so instead of fixing that we're just making a null weapon. this will become an issue when melees exist.


func _ready():
	pass
func _on_Player_fire(_direction, _pangle):
	pass
func _on_reload():
	pass
func on_hit(_damage):
	pass
