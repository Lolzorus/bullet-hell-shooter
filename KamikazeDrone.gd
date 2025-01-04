extends CharacterBody2D
@onready var explosion = $explosion1

@onready var sprite = $SpriteKamikaze
@export var death_sound :AudioStream

var death_playing : bool = false
var target_detected : bool = false
var speed = 500
var target
var enemy_health = 10:
	set(value):
		enemy_health = value
var can_hit : bool = true
var body_type = 0

func _ready():
	explosion.hide()

# going on player position	
func _physics_process(_delta):
	sprite.play("default")
	
	if target_detected and enemy_health > 0:
		var direction_to_target = (target.global_position - global_position).normalized()
		var distance_to_target = (target.global_position - global_position).length()

		velocity = direction_to_target * 750

		if distance_to_target < 150:
			velocity = direction_to_target * 400
		
	if enemy_health <= 0:
		if !death_playing:
			play_sound()
		explosion.show()
		explosion.play("default")
		body_type = 1
		speed = 700
		velocity.y = -cos(1.5 * 0.4 * 2 * PI) * 130
		can_hit = false
		death_playing = true
		
	move_and_slide()

func set_status_enemy_small(player_bullet_type):
	match player_bullet_type:
		0:
			fire()

func fire():
	enemy_health -= 10

# collision and other damage management
func _on_player_detection_body_entered(body):
	if body.get_name() == "Player ship":
		target_detected = true
		target = body
		

func _on_collision_to_player_body_entered(body):
	if body.has_method("set_status_player") and can_hit:
		body.health -= 10
		enemy_health -= 10
	pass # Replace with function body.

func play_sound():
	SoundManager.play_sound(death_sound)
	death_playing = false

func _on_explosion_1_animation_finished():
	queue_free()
	pass # Replace with function body.
