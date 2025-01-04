extends CharacterBody2D

const SPEED = 600.0

#movement for transition screen

func _process(_delta):
	velocity.x = SPEED
	move_and_slide()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://game_start.tscn")
