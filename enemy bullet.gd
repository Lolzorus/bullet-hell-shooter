extends Area2D
 
#@export var texture_array : Array[Texture2D] if needs more than 1 bullet color (for different bullet type for example)
var speed : int = 150
var direction = Vector2.RIGHT
var bullet_type : int = 0

func _physics_process(delta):
	position += direction * speed * delta
	if speed == 0:
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func set_property(type):
	bullet_type = type
	#$Sprite2D.texture = texture_array[type] if needs more than 1 bullet color

func _on_body_entered(body):
		if body.has_method("set_status_player"):
			body.set_status_player(bullet_type)
			queue_free()

