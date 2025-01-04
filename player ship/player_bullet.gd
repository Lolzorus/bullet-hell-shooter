extends Area2D

#@export var texture_array : Array[Texture2D] 
@onready var bullet_animation = $"bullet animation"
@onready var bullet_shape = $bullet_shape

signal hit_normal
signal hit_small
signal hit_boss

var speed : int = 1000
var direction = Vector2.RIGHT
var player_bullet_type : int = 0

func _physics_process(delta):
	position += direction * speed * delta
	bullet_animation.play("default")

func set_property(type):
	player_bullet_type = type

# collision management and signal emition
func _on_body_entered(body):
	if body.has_method("set_status_enemy_normal") and body.body_type == 0:
		body.set_status_enemy_normal(player_bullet_type)
		emit_signal("hit_normal")
		clean()
	if body.has_method("set_status_enemy_small") and body.body_type == 0:
		body.set_status_enemy_small(player_bullet_type)
		emit_signal("hit_small")
		clean()
	if body.has_method("set_status_boss") and body.body_type == 0:
		body.set_status_boss(player_bullet_type)
		emit_signal("hit_boss")
		clean()
		
		
func _on_visible_on_screen_enabler_2d_screen_exited():
	bullet_shape.disabled = true
	clean()

func clean():
	queue_free()

