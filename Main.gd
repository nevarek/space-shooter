extends Node2D

var EnemyScene : PackedScene = load("res://Enemy.tscn")

@onready var Player : Node2D = $Player
@onready var Level : Node2D = $Level
@onready var Enemies : Node2D = $Enemies

var num_starting_enemies = 15


func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	randomize()
	$EnemySpawnTimer.connect('timeout', _on_EnemySpawnTimer_timeout)
	
	for _n in range(0, num_starting_enemies):
		spawn_enemy_by(Player)
	
	
func _process(delta):
	if $EnemySpawnTimer.is_stopped():
		$EnemySpawnTimer.start()


func get_point_near_object(object : Node2D, min_dist, max_dist) -> Vector2:
	var rand_angle = randf_range(0, 2 * PI)
	var random_distance = randi_range(object.radius + min_dist, object.radius + max_dist)	
	var random_point = Vector2(cos(rand_angle), sin(rand_angle)) * random_distance
	
	return object.position + random_point
	

func spawn_enemy_by(target : Node2D):
	var new_enemy = EnemyScene.instantiate()
	new_enemy.position = get_point_near_object(target, 300, 1000)
	$Enemies.add_child(new_enemy)
	

func _on_EnemySpawnTimer_timeout():
	spawn_enemy_by(Player)
	$EnemySpawnTimer.start()


func end_game():
	get_tree().quit()
