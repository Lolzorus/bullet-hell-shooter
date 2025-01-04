extends CharacterBody2D

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var bullet_node: PackedScene
@export var wander_direction1 : Node2D

@onready var progress_bar = $CanvasLayer/ProgressBar
@onready var end = $end

var body_type = 0
var can_shoot : bool = true
var bullet_offset = Vector2(-150,0)
var bullet_type: int = 0
var speed : int = 350
var boss_position : Vector2
var boss_dead : bool = false
var checker : bool = false

var boss_health = 2500:
	set(value):
		boss_health = value
		progress_bar.value = value

# helper function to define bullet direction with theta
func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))

	
func _physics_process(_delta):
	velocity = wander_direction1.direction * 300
	
	# movement when death
	if boss_health <= 0:
		boss_dead= true
		start_end()
		body_type = 1
		speed = 700
		velocity.y = -cos(1.5 * 0.4 * 2 * PI) * 130
		can_shoot = false
	else:
		pass
	
		
	move_and_slide()

# Call for transition when boss is dead
func start_end():
	if boss_dead and !checker:
		end.start()
		checker = true

# Boss shoot function and instance of bullet
func shoot(angle):
	if can_shoot:
		var bullet = bullet_node.instantiate()
		bullet.position = global_position + bullet_offset
		bullet.direction = get_vector(angle)
		bullet.set_property(bullet_type)
		get_tree().current_scene.call_deferred("add_child",bullet)
		bullet.speed = 300
		if boss_health <= 2500:
			speed = 500
			bullet.speed = 500
 
#when shoot timer is out
func _on_speed_timeout():
		shoot(theta)

func set_status_boss(player_bullet_type):
	match player_bullet_type:
		0:
			fire()

func fire():
	boss_health -= 10
	#debug_2.text = "toucher"


func _on_end_timeout():
	get_tree().change_scene_to_file("res://transition.tscn")
	queue_free()
	progress_bar.hide()
	pass # Replace with function body.
