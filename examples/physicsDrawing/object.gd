extends RigidBody2D
class_name phyObj

@export var colPolygon : CollisionPolygon2D
@export var visPolygon : Polygon2D

var poly : PackedVector2Array = []
var pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	colPolygon.polygon = poly
	visPolygon.polygon = poly
	position = pos
	linear_velocity = Vector2.ZERO

func setVars(_polygon : PackedVector2Array, _position: Vector2) -> void: # function to easily set polygons
	poly = _polygon
	pos = _position
