extends CharacterBody2D

var speed : int = 450
@export var bullet_node : PackedScene
@onready var timer = $Timer
@onready var timerbullet = $timerbullet
@onready var explosion = $explosion

var death_playing : bool = false
@export var death_sound : AudioStream

var bullet_offset = Vector2(-100, 0)
var bullet_type: int = 1
var bullets_fired = 0
var go_left : bool = true
var can_shoot : bool = true
var body_type = 0
var enemy_health = 10:
	set(value):
		enemy_health = value
 
func _ready():
	explosion.hide()

func _physics_process(_delta):
	if position.x > -1000 and go_left:
		velocity.x = -speed
		can_shoot = false
		
	if position.x <= 0:
		can_shoot = true
		go_left = false
		velocity.x = speed
		if position.y <= 250:
			velocity.y = 250
		else:
			velocity.y = -250
			
	if enemy_health <= 0 or velocity.x == 0 or position.x > 1300:
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
		bullet.direction = Vector2.LEFT
		bullet.set_property(bullet_type)
		bullet.speed = 900
		get_tree().current_scene.call_deferred("add_child",bullet)


func _on_timerbullet_timeout():
	if bullets_fired < 5:
		shoot()
		bullets_fired +=1
		
func set_status_enemy_small(player_bullet_type):
	match player_bullet_type:
		0:
			fire()

func fire():
	enemy_health -= 10

func _on_timer_timeout():
	bullets_fired = 0


func _on_collision_to_player_body_entered(body):
	if body.has_method("set_status_player"):
			body.health -= 10
			enemy_health -= 10

func _on_explosion_animation_finished():
	queue_free()
	pass # Replace with function body.

func play_sound():
	SoundManager.play_sound(death_sound)
	death_playing = false
