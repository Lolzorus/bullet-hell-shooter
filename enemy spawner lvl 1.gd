extends Node2D
@onready var wave_timer = $WaveTimer
@onready var waver_number = $WaveNumber
@onready var spawn_timer = $SpawnTimer
@onready var enemy_spawn = $enemy_spawn

# all type of enemies and items that can be summoned by the spawner (can add more scene here)
@export var kamikaze_node : PackedScene
@export var zigzag_node : PackedScene
@export var random_node : PackedScene
@export var circle_node : PackedScene
@export var z_node : PackedScene
@export var tower_3_shoot : PackedScene
@export var weapon_bonus : PackedScene
@export var heal : PackedScene
@export var boss_node : PackedScene

var can_summon : bool = false

func _ready():
	enemy_spawn.hide()
	pass
	
var wave : int = -1:
	set(value):
		wave = value
		waver_number.text = "Wave : " + str(value)
		enemy_spawn.hide()
		
func _input(event):
	if event.is_action_pressed("pause"):
		if can_summon:
				# Pause the game: Stop all timers and spawning
			wave_timer.stop()
			enemy_spawn.hide()
		else:
				# Unpause the game: Resume the wave timer
			wave_timer.start()
			enemy_spawn.hide()
		can_summon = !can_summon

#what the spawner spawn and when
func _on_wave_timer_timeout():
		wave += 1
		match wave:
			1,2,15,18,19,20,21,23:
				spawn_kamikaze()
		match wave:
			3,4,15,18,20,21,22,23:
				spawn_trio_shoot()
		match wave:
			5,18,20,21,23:
				spawn_big_random()
		match wave:
			6,7,16,19,23:
				spawn_z()
				spawn_z()
		match wave:
			8,9,10,17,19,20,21:
				spawn_circle()
		match wave:
			11,12,13,17,19,21,23:
				spawn_tower_3()
		match wave:
			14:
				spawn_heal()
				spawn_bonus()
		match wave:
			22:
				spawn_tower_3()
		match wave:
			23:
				spawn_circle()
		match wave:
			24:
				spawn_bonus()
		match wave:
			25:
				spawn_boss()


### individual spawn instance behavior ###


func spawn_kamikaze():
	var spawn_count : int = 5
	for count in range(spawn_count):
		var kamikaze = kamikaze_node.instantiate()
		
		# Generate a random position for each kamikaze instance
		var random_x = randi_range(1200, 1300)  # Random X position
		var random_y = randi_range(100, 700)   # Random Y position
		kamikaze.position = Vector2(random_x, random_y)
		
		# Add the kamikaze to the scene
		call_deferred("add_child", kamikaze)
		
		# Wait between spawns
		await get_tree().create_timer(0.2).timeout
		spawn_timer.start()
		
func spawn_trio_shoot():
	var spawn_count : int = 3
	for count in range(spawn_count):
		var zigzag = zigzag_node.instantiate()
		
		var random_x = randi_range(1200, 1300)  # Random X position
		var random_y = randi_range(100, 500)   # Random Y position
		zigzag.position = Vector2(random_x, random_y)
		
		call_deferred("add_child", zigzag)
		
		await get_tree().create_timer(0.5).timeout
		
func spawn_big_random():
	var spawn_count : int = 3
	for count in range(spawn_count):
		var random = random_node.instantiate()
		
		var random_x = randi_range(1200, 1300)  # Random X position
		var random_y = randi_range(100, 500)   # Random Y position
		random.position = Vector2(random_x, random_y)
		
		call_deferred("add_child", random)
		
		await get_tree().create_timer(0.5).timeout
		#enemy2.position = Vector2(100, randf_range(100, 450))
		#await get_tree().create_timer(0.5).timeout
		#spawn_timer.start()
		#call_deferred("add_child", enemy2)
	#
func spawn_circle():
	var spawn_count : int = 5
	for count in range(spawn_count):
		var enemy_circle = circle_node.instantiate()

		var random_x = randi_range(1200, 1300)  # Random X position
		var random_y = randi_range(200, 400)   # Random Y position
		enemy_circle.position = Vector2(random_x, random_y)
		
		call_deferred("add_child", enemy_circle)
		
		await get_tree().create_timer(0.5).timeout
#
func spawn_z():
	var spawn_count : int = 5
	for count in range(spawn_count):
		var random_position = randi_range(0, 1)
		var z_enemy = z_node.instantiate()
		if random_position == 0:
			z_enemy.position = Vector2(1200, 50)
		else:
			z_enemy.position = Vector2(1200, 500)
		await get_tree().create_timer(0.3).timeout
		spawn_timer.start()
		call_deferred("add_child", z_enemy)
#
func spawn_tower_3():
	var spawn_count : int = 3
	var positions = [Vector2(1200, 100), Vector2(1200, 300), Vector2(1200, 500)]
	for count in range(spawn_count):
		var enemy = tower_3_shoot.instantiate()
		enemy.position = positions[count]
		spawn_timer.start()
		call_deferred("add_child", enemy)
#
#
func spawn_boss():
	var boss = boss_node.instantiate()
	boss.position = Vector2(1200, randf_range(200, 500))
	call_deferred("add_child", boss)
	#
func spawn_bonus():
	var bonus = weapon_bonus.instantiate()
	bonus.position = Vector2(1200, randf_range(400, 500))
	call_deferred("add_child", bonus)
	#
func spawn_heal():
	var healing = heal.instantiate()
	healing.position = Vector2(1200, randf_range(200, 300))
	call_deferred("add_child", healing)
