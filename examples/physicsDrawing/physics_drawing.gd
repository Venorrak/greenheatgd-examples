extends Node2D

@export var heat : GreenHeat
@export var objectScene : PackedScene

var lines : Dictionary[String, Line2D] = {} # memory with each twitchId pointing to their Line (drawing)
var width : int = 2

func _ready() -> void:
	# connect needed Greenheat signals
	heat.click_received.connect(_click_received)
	heat.release_received.connect(_release_received)
	heat.drag_received.connect(_drag_received)

func _click_received(packet: Dictionary) -> void: # create line with initial point and add to the memory
	var newLine : Line2D = Line2D.new()
	newLine.add_point(Vector2.ZERO)
	newLine.width = width
	newLine.position = _get_position_from_packet(packet)
	add_child(newLine)
	lines.set(packet["id"], newLine)

func _release_received(packet: Dictionary) -> void:
	var line = lines.get(packet["id"])
	if line:
		# get polygon from array of Vectors 
		var polygon : Array[PackedVector2Array] = Geometry2D.offset_polyline(line.points, width, Geometry2D.JOIN_ROUND)
		var newObject = objectScene.instantiate()
		newObject.setVars(polygon[0], line.position)
		add_child(newObject) # create object with physics and collisionPolygon
		line.queue_free() # delete the drawing line
	lines.erase(packet["id"])
	
func _drag_received(packet: Dictionary) -> void:
	var line = lines.get(packet["id"])
	if line:
		line.add_point(_get_position_from_packet(packet) - line.position) # add point to line if it exists

func _get_position_from_packet(packet: Dictionary) -> Vector2:
	return Vector2(packet["x"], packet["y"]) * get_tree().root.get_visible_rect().size
