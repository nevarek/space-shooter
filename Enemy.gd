extends CharacterBody2D

@onready var Main = get_tree().get_first_node_in_group('MAIN')
var speed = 30

var health = 1
var damage = 1
var score_points_value = 1


func _ready():
	pass
	
	
func _physics_process(delta):
	_calculate_motion_velocity()
	var collision = move_and_collide(motion_velocity * delta)
	if collision:
		_on_collision(collision.get_collider())
	

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		

func _on_collision(body):
	if body.is_in_group('players'):
		body.take_damage(damage)
		die()
	if body.is_in_group('bullets'):
		take_damage(body.damage)
		body.shot_by.score_points(score_points_value)
		body.queue_free()

	
func die():
	queue_free()


func _get_nearest_player():
	var players_list = get_tree().get_nodes_in_group('players')
	var nearest_player = players_list[0]
	var nearest_distance = position.distance_to(nearest_player.position)
	
	for player in players_list.slice(1, len(players_list)):
		var distance_to_player = position.distance_to(player)
		if distance_to_player < nearest_distance:
			nearest_player = player
			nearest_distance = distance_to_player

	return nearest_player
	

func _calculate_motion_velocity():
	var dir = (_get_nearest_player().position - position).normalized()
	motion_velocity = speed * dir
