extends CharacterBody2D

var theta: float = 1.3
@export_range(0,1*PI) var alpha: float = 1.3
@export var bullet_node: PackedScene
@onready var shoot_timer = $"shoot timer"
@onready var sprite = $sprite
@onready var explosion = $explosion1


var death_playing : bool = false
@export var death_sound : AudioStream
var target_detected : bool = false
var target
var body_type = 0
var direction : Vector2 = Vector2.LEFT
var bullet_offset = Vector2(-100, 0)
var bullet_type: int = 0
var speed : int = 350
var can_shoot : bool = true

# time variable of movement
var time_passed = 0

var enemy_health = 20:
	set(value):
		enemy_health = value
 
func _ready():
	sprite.play("default")
	explosion.hide()
	velocity = direction * speed

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))

func _physics_process(_delta):
	velocity.x = -speed
	
	if enemy_health == 0 or velocity.x == 0 or is_on_wall():
		if !death_playing:
			play_sound()
			
		explosion.show()
		explosion.play("default")
		body_type = 1
		speed = 700
		velocity.y = -cos(1.5 * 0.4 * 2 * PI) * 130
		can_shoot = false
		death_playing = true
		
	move_and_slide()
	
	
func shoot(angle):
	if can_shoot:
		var bullet = bullet_node.instantiate()
		bullet.position = global_position + bullet_offset
		bullet.direction = get_vector(angle)
		bullet.set_property(bullet_type)
		bullet.speed = 700
		get_tree().current_scene.call_deferred("add_child",bullet)
 

func _on_collision_to_player_body_entered(body):
	if body.has_method("set_status_player"):
		body.health -= 10
		enemy_health -= 20


func _on_player_detection_body_entered(body):
	if body.get_name() == "Player ship":
		target_detected = true
		target = body


func _on_shoot_timer_timeout():
	shoot(theta)

func set_status_enemy_normal(player_bullet_type):
	match player_bullet_type:
		0:
			fire()

func fire():
	enemy_health -= 10



func _on_explosion_1_animation_finished():
	queue_free()
	pass # Replace with function body.
	
func play_sound():
	SoundManager.play_sound(death_sound)
	death_playing = false
