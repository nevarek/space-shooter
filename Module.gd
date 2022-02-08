extends Node2D

@onready var Main = get_tree().get_first_node_in_group('MAIN')
var BulletScene = load('res://Bullet.tscn')

var facing_direction : Vector2
var shooting_speed = 1
var bullet_speed = 300

var enabled = false :
	set(value):
		enabled = value
		visible = value


func init():
	$ShootTimer.wait_time = shooting_speed
	$ShootTimer.connect('timeout', shoot)
	$ShootTimer.start()


func shoot():
	if not enabled: return
	
	var new_bullet = BulletScene.instantiate()
	new_bullet.position = $ShootPoint.global_position
	var bullet_motion_dir = new_bullet.position - global_position
	new_bullet.init(bullet_motion_dir, bullet_speed)
	new_bullet.shot_by = find_parent('Player')
	
	Main.add_child(new_bullet)
	$ShootTimer.start()
	
