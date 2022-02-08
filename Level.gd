extends Node2D

@export var level_radius = 2000
var shape_segments = 360
var border_thickness = 30

func _ready():
	_create_collision_shape()

func _draw():
	#draw_circle(Vector2.ZERO, level_radius, Color('white', 0.33))
	draw_arc(Vector2.ZERO, level_radius + border_thickness/2, 0, 2 * PI, 360,  Color('white', 0.33), border_thickness)


func _create_collision_shape():
	# generates points along an arc (full circle)
	var polygon_points = PackedVector2Array()
	var angle_from = 0
	var angle_to = 2 * PI
	
	for segment in range(shape_segments + 1):
		var angle_point = angle_from + segment * (angle_to-angle_from) / shape_segments - PI / 2
		polygon_points.push_back(Vector2(cos(angle_point), sin(angle_point)) * level_radius)
	
	$StaticBody2D/CollisionPolygon2D.polygon = Geometry2D.convex_hull(polygon_points)
	
	
