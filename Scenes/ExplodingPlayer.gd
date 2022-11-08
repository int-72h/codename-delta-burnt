extends Node2D

#my job is to explode

func explode():
	$Head.explode()
	$Torso.explode()
	$Bottom.explode()
