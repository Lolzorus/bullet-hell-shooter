extends CharacterBody2D

var speed = 250

# heal item variable

func _physics_process(_delta):
	velocity.x = -speed
	
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if "Player ship" in body.name:
		body.heal()
		queue_free()
