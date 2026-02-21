extends Control

var rect : Rect2
var userId : String = ""
var relativePosition : Vector2 = Vector2.ZERO

func _ready() -> void:
	greenHeat.click_received.connect(_click_received)
	greenHeat.release_received.connect(_release_received)
	greenHeat.drag_received.connect(_drag_received)
	
	rect = get_rect()
	rect.position = global_position

func _click_received(packet : Dictionary) -> void:
	if userId.is_empty() && rect.has_point(_position_global(packet)):
		userId = packet["id"]
		relativePosition = _position_global(packet) - rect.position

func _release_received(packet : Dictionary) -> void:
	if packet["id"] == userId:
		userId = ""
		relativePosition = Vector2.ZERO

func _drag_received(packet: Dictionary) -> void:
	if packet["id"] == userId:
		global_position = _position_global(packet) - relativePosition
		rect.position = global_position


func _position_in_screen(packet : Dictionary) -> Vector2:
	return Vector2(float(packet["x"]), float(packet["y"])) * get_tree().root.get_visible_rect().size

func _position_global(packet: Dictionary) -> Vector2:
	return _position_in_screen(packet) + get_viewport_rect().position
