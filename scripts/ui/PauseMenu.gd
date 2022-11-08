extends Control

var unpause = false
func _ready():
	pass

func _input(event):
	if event is InputEventKey and event.pressed == true and get_tree().paused:
		if event.scancode == KEY_ESCAPE:
			unpause = true


func _on_Button_pressed(): #continue
	get_tree().paused = false
	hide()


func _on_Button2_pressed(): #quit
	get_tree().quit()


func _on_Button3_pressed(): #restart
	get_tree().change_scene("res://Scenes/Level1.tscn")
	get_tree().paused = false

func _process(_delta):
	if get_tree().paused == true and unpause == true:
		set_process_input(true)
		unpause = false
		_on_Button_pressed()
		
