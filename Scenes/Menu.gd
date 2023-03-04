extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grunt = preload("res://assets/grunt.mp3")
var clink = preload("res://assets/clink.wav")
var slide = preload("res://assets/slide.wav")
var basepos = global_position
func _ready():
	#$MainLogo.set("modulate",Color.transparent)
	$Alpha.set("modulate",Color.transparent)
	$Alpha2.set("modulate",Color.transparent)
	yield(get_tree().create_timer(2.0), "timeout")
	$AudioStreamPlayer2D.stream = slide
	$AudioStreamPlayer2D.play()
	var tween = get_tree().create_tween().set_parallel()
	var logos = [$MainLogo,$MainLogo2,$MainLogo3,$MainLogo5]
	for x in logos:
		tween.tween_property(x,"rect_position",$Node2D.rect_global_position - Vector2(750,100),1).set_trans(Tween.TRANS_SINE)
		tween.tween_property(x,"custom_colors/font_color",Color.white,1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Alpha,"modulate",Color.white,1.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Alpha2,"modulate",Color.white,1.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Alpha,"rect_position",$Node2D.rect_global_position - Vector2(450,50),1.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Alpha2,"rect_position",$Node2D.rect_global_position - Vector2(450,50),1.1).set_trans(Tween.TRANS_SINE)
	yield(get_tree().create_timer(1.2), "timeout")
	$AudioStreamPlayer2D.stream = clink
	$AudioStreamPlayer2D.play()


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
	
