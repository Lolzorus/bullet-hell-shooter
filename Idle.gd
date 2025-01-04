extends State

@onready var collision = %CollisionShape2D

# boss idle status

var player_entered : bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)


func transition():
	if player_entered:
		get_parent().change_state("5")


func _on_player_detection_body_entered(_body):
	player_entered = true
	pass # Replace with function body.
