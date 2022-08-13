extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grunt = preload("res://assets/grunt.mp3")
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_Button2_pressed():
	get_tree().quit()


func _on_Button3_pressed():
	$AudioStreamPlayer2D.stream = grunt
	$AudioStreamPlayer2D.play()
	
