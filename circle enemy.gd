extends CharacterBody2D

var speed : int = 300
var amplitude = 450 # movement gap (up down)
var frequency = 0.35 # movement frequency in Hz

# Time variable for movement
var time_passed = 0
var mouvement_offset : float

@export var death_sound : AudioStream
@export var bullet_node : PackedScene
@onready var explosion = $explosion
@onready var sprite = $Sprite
@onready var shoot_timer = $shoot_timer

var death_playing : bool = false
var target
var target_detected : bool = false
var bullet_offset = Vector2(-100, 0)
var bullet_type: int = 0
var can_shoot : bool = true
var body_type = 0
var enemy_health = 10:
	set(value):
		enemy_health = value

func _ready():
	explosion.hide()

func _physics_process(delta):
	sprite.play("default")
	time_passed += delta

	# Movement calculation
	velocity.x = sin(time_passed * frequency * 2 * PI) * amplitude - 150
	velocity.y = cos(time_passed * frequency * 2 * PI) * amplitude 
	
	if enemy_health <= 0 or velocity.x == 0 or position.x < -1200:
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
	
func shoot(): # bullet instantiation
	if can_shoot:
		var bullet = bullet_node.instantiate()
		bullet.position = global_position + bullet_offset
		bullet.direction = Vector2.LEFT
		bullet.set_property(bullet_type)
		bullet.speed = 700
		get_tree().current_scene.call_deferred("add_child",bullet)



	
func set_status_enemy_small(player_bullet_type):
	match player_bullet_type:
		0:
			fire()

func fire():
	enemy_health -= 10

# Damage and other collision management
func _on_player_detection_body_entered(body):
	if body.get_name() == "Player ship":
		target_detected = true
		target = body

func _on_collision_to_player_body_entered(body):
	if body.has_method("set_status_player"):
			GlobalPlayer.health -= 10
			enemy_health -= 10


func _on_shoot_timer_timeout():
	shoot()
	pass # Replace with function body.

func play_sound():
	SoundManager.play_sound(death_sound)
	death_playing = false
	
func _on_explosion_animation_finished():
	queue_free()
	pass # Replace with function body.
