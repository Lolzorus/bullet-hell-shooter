extends CharacterBody2D

@export var bullet_node: PackedScene
@onready var explosion = $explosion1
@onready var sprite_2d = $Sprite2D

var direction
var target_detected : bool = false
var target
var enemy_health = 10:
	set(value):
		enemy_health = value
var bullet_offset = Vector2(-50, 2)
var bullet_type: int = 0
var bullets_fired = 0
var can_shoot : bool = false
var body_type = 0
var death_playing : bool = false
@export var death_sound :AudioStream

func _ready():
	explosion.hide()
	
func _physics_process(_delta):
	if target_detected:
		can_shoot = true
		velocity = global_position.normalized() * -700
		if position.x <= 1000:
			velocity = Vector2.ZERO
		
	if enemy_health <= 0 or is_on_wall():
		if !death_playing:
			play_sound()
			
		explosion.show()
		explosion.play("default")
		body_type = 1
		velocity.y = -cos(1.5 * 0.4 * 2 * PI) * 130
		can_shoot = false
		death_playing = true
		
	move_and_slide()

# multi bullet and direction instance
func shoot():
	if can_shoot:
		var angle = 5
		
		var bullet_node1 = bullet_node.instantiate()
		var bullet_node2 = bullet_node.instantiate()
		var bullet_node3 = bullet_node.instantiate()
		
		bullet_node1.position = global_position + bullet_offset # Adjust position as needed
		direction = (target.global_position - global_position)
		bullet_node1.direction = direction.rotated(deg_to_rad(angle)).normalized()
		bullet_node1.set_property(bullet_type) # Set properties as needed
		bullet_node1.speed = 400
		get_tree().current_scene.call_deferred("add_child",bullet_node1)

		bullet_node2.position = global_position + bullet_offset  
		bullet_node2.set_property(bullet_type)  
		direction = (target.global_position - global_position)
		bullet_node2.direction = direction.normalized()
		bullet_node2.speed = 400
		get_tree().current_scene.call_deferred("add_child",bullet_node2)
		
		bullet_node3.position = global_position + bullet_offset 
		direction = (target.global_position - global_position)
		bullet_node3.direction = direction.rotated(deg_to_rad(-angle)).normalized()
		bullet_node3.set_property(bullet_type)
		bullet_node3.speed = 400
		get_tree().current_scene.call_deferred("add_child",bullet_node3)

func _on_timerbullet_timeout():
	if bullets_fired < 3:
		shoot()
		bullets_fired +=1

func _on_timer_timeout():
	bullets_fired = 0

func set_status_boss(player_bullet_type):
	match player_bullet_type:
		0:
			fire()


# collision and other management

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
		$Sprite2D.visible = false

func _on_explosion_1_animation_finished():
	queue_free()
	pass # Replace with function body.

func play_sound():
	SoundManager.play_sound(death_sound)
	death_playing = false
