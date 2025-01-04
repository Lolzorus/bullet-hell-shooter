extends Node2D
@onready var player_scene = preload("res://player ship/player_ship.tscn")
@onready var parallax_container = $parallax_container
@onready var current_background_index = 0


func _on_start_pressed():
	get_tree().change_scene_to_file("res://1_st_level.tscn")

func _ready():
	spawn()

func spawn():
	var player = player_scene.instantiate()
	add_child(player)
	player.position= Vector2(100,100)

func _input(event):
	if event.is_action_pressed("next background"):
		_next_background()
		_update_background_visibility()
	
	if event.is_action_pressed("previous background"):
		_previous_background()
		_update_background_visibility()


### Logic to handle background switch###
func _next_background():
	var children = parallax_container.get_children()
	if children.size() == 0:
		print("No parallax backgrounds found!")
		return
	
	# Hide current background
	children[current_background_index].visible = false
	
	# Update index
	current_background_index = (current_background_index + 1) % children.size()
	
	# Show next background
	children[current_background_index].visible = true
	print("Switched to background:", current_background_index)

func _previous_background():
	var children = parallax_container.get_children()
	if children.size() == 0:
		print("No parallax backgrounds found!")
		return
	
	# Hide current background
	children[current_background_index].visible = false
	
	# Update index
	if current_background_index == 0:
		current_background_index = children.size() - 1
	else:
		current_background_index -= 1
	
	
	# Show next background
	children[current_background_index].visible = true
	print("Switched to background:", current_background_index)

func _update_background_visibility():
	# Ensure only the current background is visible
	var children = parallax_container.get_children()
	for i in range(children.size()):
		children[i].visible = (i == current_background_index)
