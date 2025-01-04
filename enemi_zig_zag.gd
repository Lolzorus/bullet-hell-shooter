extends CharacterBody2D


@export_range(2,2*PI) var alpha: float = 40.0
@export var bullet_node: PackedScene
@onready var shoot_timer = $shoot_timer

@onready var explosion = $explosion

@export var death_sound : AudioStream
var death_playing : bool = false
var target
var direction : Vector2 = Vector2.LEFT
var body_type = 0
var angle = 30 # Angle in degrees
var bullet_offset = Vector2(-60, 0)
var bullet_type: int = 0
var speed : int = 500

var amplitude = 135 # Movement gap (up down)
var frequency = 0.4 # Fréquency in Hz
var target_detected : bool = false
var can_shoot : bool = true

# Variable de temps pour contrôler la direction du zigzag
var time_passed = 0

var enemy_health = 10:
	set(value):
		enemy_health = value
 
func _ready():
	velocity = direction * speed
	explosion.hide()

func _physics_process(delta):
	time_passed += delta
	velocity.y = cos(time_passed * frequency * 2 * PI) * amplitude
	
	if enemy_health == 0  or is_on_wall():
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
	

func shoot():
	if can_shoot:
		var bullet = bullet_node.instantiate()
		bullet.position = global_position + bullet_offset
		direction = (target.global_position - global_position)
		bullet.direction = direction.normalized()

		bullet.set_property(bullet_type)
		get_tree().current_scene.call_deferred("add_child", bullet)
		bullet.speed = 700
 
func _on_shoot_timer_timeout():
	shoot()
	pass # Replace with function body.
	
	
func set_status_enemy_normal(player_bullet_type):
	match player_bullet_type:
		0:
			fire()

func fire():
	enemy_health -= 10

func _on_player_detection_body_entered(body):
	if body.get_name() == "Player ship":
		target_detected = true
		target = body

func _on_collision_to_player_body_entered(body):
	if body.has_method("set_status_player"):
			body.health -= 10
			enemy_health -= 10

			
#for weird shooting angle
	#if position.y < 250:
		#direction = Vector2(-cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))  # Using trigonometry to calculate the direction
		#bullet.direction = direction.normalized()
	#else:
		#direction = Vector2(-cos(deg_to_rad(angle)), -sin(deg_to_rad(angle)))  # Using trigonometry to calculate the direction
		#bullet.direction = direction.normalized()

# for circle movement
#func enemy_move(delta):
	#time_passed += delta
#
	## movement calculation
	#var x_movement = sin(time_passed * frequency * 2 * PI) * amplitude
	#var y_movement = cos(time_passed * frequency * 2 * PI) * amplitude
#
	## horizontal movement
	#var motion = Vector2(x_movement, y_movement).normalized() * speed * delta
	#move_and_collide(motion)

func _on_explosion_animation_finished():
	queue_free()
	pass # Replace with function body.

func play_sound():
	SoundManager.play_sound(death_sound)
	death_playing = false

