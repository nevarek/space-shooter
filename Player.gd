extends CharacterBody2D

@onready var Main = get_tree().get_first_node_in_group('MAIN')

var ModuleScene = load("res://Module.tscn")

var score = 0
var max_health = 5
var health

var speed = 350
var radius = 64

var num_module_anchors = 6
var modules = []:
	get:
		return $Modules.get_children()


func _ready():
	init()
	

func init():
	_mount_modules()
	modules[0].enabled = true
	for module in modules.slice(1, len(modules)):
		module.enabled = false
	
	health = max_health
	global_position = Vector2.ZERO
	modules.resize(num_module_anchors)
	_update_ui()


func _physics_process(_delta):
	calculate_motion_velocity()
	move_and_slide()
	

func calculate_motion_velocity():
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed('move_up'):
		dir.y -= 1
	if Input.is_action_pressed('move_down'):
		dir.y += 1
	if Input.is_action_pressed('move_left'):
		dir.x -= 1
	if Input.is_action_pressed('move_right'):
		dir.x += 1
	
	motion_velocity = dir.normalized() * speed


func _input(event):
	if event.is_action_released('special'):
		print('special used')
		
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		
	_update_ui()

		
func die():
	Main.end_game()
	
	
func _update_ui():
	$GUICanvasLayer.health_label.text = str(health)
	$GUICanvasLayer.score_label.text = str(score)


func _mount_modules():
	for k in num_module_anchors:
		var tk = 2 * PI * k / num_module_anchors
		var new_module = ModuleScene.instantiate()
		new_module.position = position + radius * Vector2(cos(tk), sin(tk))
		new_module.facing_direction = position - new_module.position
		new_module.rotate(new_module.facing_direction.angle() + PI / 2)
		new_module.init()
		$Modules.add_child(new_module)


func score_points(amount):
	score += amount
	_update_ui()
