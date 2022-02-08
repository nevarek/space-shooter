extends CharacterBody2D

var speed : float
var direction : Vector2
var _total_distance_moved : float = 0.0
var shot_by : Node2D

@export var damage = 1


func init(_direction, _speed):
	direction = _direction
	speed = _speed
	motion_velocity = direction.normalized() * speed


func _physics_process(delta):
	move_and_slide()
	_total_distance_moved = motion_velocity.length() * delta
	
	if _total_distance_moved > 10000:
		queue_free()
