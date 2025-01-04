extends CharacterBody2D
@export var movement : AnimationPlayer
@export var bullet : PackedScene
@onready var exhaust = $exhaust
@onready var player_ship = $"."
@onready var cooldown_timer = $cooldown_timer
@onready var laser_sound = $laser_sound
@onready var laser_out = $"laser out"
@onready var number_of_life = $"CanvasLayer/number of life"
@onready var tilting_timer = $tilting_timer

@onready var invinsibility_frame = $"invinsibility frame"
@onready var scoring = $CanvasLayer/scoring
@onready var progress_bar = $CanvasLayer/ProgressBar


signal player_dead

var bullet_offset : Vector2 = Vector2(58,4)
var player_bullet_type: int = 0
var can_shoot : bool = true
var triple_shoot : bool = false
var quint_shoot : bool = false
var got_hit : bool = false

var score = 0:
	set(value_score):
		score = value_score
		scoring.text = str(value_score)
		
var health = GlobalPlayer.health:
	set(value):
		health = value
		progress_bar.value = value


func _ready():
	laser_out.hide()
	exhaust.play("exhaust low")
	# Check if the root scene is "game_start"
	if get_tree().current_scene.name == "game_start":
		print("Player is in 'game_start' scene")
		progress_bar.visible = false
		scoring.visible = false
	else:
		print("Player is NOT in 'game_start' scene")
		progress_bar.visible = true
		scoring.visible = true

func _physics_process(_delta):
	GlobalPlayer.health = health

	if health <= 0:
		emit_signal("player_dead")
		GlobalPlayer.health = 100
		call_deferred("queue_free")
	
	number_of_life.text = "Number of life: " + str(GlobalPlayer.life_number)
	
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down") * GlobalPlayer.speed
	
	#exhaust
	if player_ship.velocity.x > 0 :
		exhaust.play("exhaust high")
	else:
		exhaust.play("exhaust low")
		
	#shoot
	if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
		player_shoot()
		laser_out.show()
		laser_out.play("default")
		laser_sound.play()
		pass
	
	if Input.is_action_just_released("shoot"):
		laser_out.hide()
			
	move_and_slide()
	

func _input(event):
	#basic movement animation
	if event.is_action_pressed("ui_up"):
		movement.play("up")
	if event.is_action_pressed("ui_down"):
		movement.play("down")
		pass
		
	if event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		movement.play("standard")

#player status if shot by a specific bullet (can add more effect)
func set_status_player(bullet_type):
	match bullet_type:
		0:
			fire()
		#1:
			#shock()
		#2:
			#slow()
		#3:
			#stun()

func fire():
	if !got_hit:
		health -= 10
		got_hit = true
		#ap.play("explode")
		invinsibility_frame.start()
		

# player bullet shot physic (1 3 5 bullets more can be added)
func player_shoot():
	if can_shoot == true:
		var player_bullet = bullet.instantiate()
		player_bullet.position = global_position + bullet_offset
		player_bullet.set_property(player_bullet_type)
		get_tree().current_scene.call_deferred("add_child",player_bullet)
		cooldown_timer.start()
		# connect to signal depending of enemy size (for score)
		player_bullet.connect("hit_small", _on_hit_small)
		player_bullet.connect("hit_normal", _on_hit_normal)
		player_bullet.connect("hit_boss", _on_hit_boss)
		
	if can_shoot and triple_shoot:
		var angle = 165
		
		var player_bullet1 = bullet.instantiate()
		var player_bullet3 = bullet.instantiate()
		
		player_bullet1.position = global_position + Vector2(58,15)
		player_bullet1.direction = Vector2(-cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))  # Using trigonometry to calculate the direction
		player_bullet1.direction = player_bullet1.direction.normalized()
		player_bullet1.set_property(player_bullet_type)
		get_tree().current_scene.call_deferred("add_child",player_bullet1)

		
		player_bullet3.position = global_position + Vector2(58,-15)  # Adjust position as needed
		player_bullet3.direction = Vector2(-cos(deg_to_rad(angle)), -sin(deg_to_rad(angle)))  # Using trigonometry to calculate the direction
		player_bullet3.direction = player_bullet3.direction.normalized()
		player_bullet3.set_property(player_bullet_type)
		get_tree().current_scene.call_deferred("add_child",player_bullet3)

		
	if can_shoot and quint_shoot:
			
		var player_bullet4 = bullet.instantiate()
		var player_bullet5 = bullet.instantiate()

		player_bullet4.position = global_position + Vector2(58,15)  # Adjust position as needed
		player_bullet4.set_property(player_bullet_type)  # Set properties as needed
		get_tree().current_scene.call_deferred("add_child",player_bullet4)
			
		player_bullet5.position = global_position + Vector2(58,-15) # Adjust position as needed
		player_bullet5.set_property(player_bullet_type)  # Set properties as needed
		get_tree().current_scene.call_deferred("add_child",player_bullet5)

# Switch for power up and heal
func power_up():
	if triple_shoot == false:
		triple_shoot = true
	else:
		quint_shoot = true

func heal():
	health +=50
	if health > 100:
		health = 100


func _on_invinsibility_frame_timeout():
	got_hit = false
	pass # Replace with function body.

# score management when bullet hit enemy by size
func _on_hit_small():
	score += 50

func _on_hit_normal():
	score += 100


func _on_hit_boss():
	score += 150
	

func _on_tilting_timer_timeout():
	movement.play("standard")
	pass # Replace with function body.
