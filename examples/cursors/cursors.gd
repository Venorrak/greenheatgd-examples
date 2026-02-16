extends Node2D

@export var greenHeat : GreenHeat
@export var cursorScene : PackedScene

var cursors : Dictionary[String, Cursor] = {}

func _ready() -> void:
	greenHeat.click_received.connect(_click_received)
	greenHeat.drag_received.connect(_drag_received)
	greenHeat.hover_received.connect(_hover_received)
	greenHeat.release_received.connect(_release_received)

func _click_received(packet: Dictionary) -> void:
	var cur = cursors.get(packet['id'])
	if not cur: _create_cursor(packet); return
	cur.targetPosition = _get_position_from_packet(packet)
	cur.lastPing = 0
	cur.state = Cursor.cursorState.GRABBING

func _drag_received(packet: Dictionary) -> void:
	var cur = cursors.get(packet['id'])
	if not cur: _create_cursor(packet); return
	cur.targetPosition = _get_position_from_packet(packet)
	cur.lastPing = 0
	cur.state = Cursor.cursorState.GRABBING

func _hover_received(packet: Dictionary) -> void:
	var cur = cursors.get(packet['id'])
	if not cur: _create_cursor(packet); return
	cur.targetPosition = _get_position_from_packet(packet)
	cur.lastPing = 0
	cur.state = Cursor.cursorState.POINTING

func _release_received(packet: Dictionary) -> void:
	var cur = cursors.get(packet['id'])
	if not cur: _create_cursor(packet); return
	cur.targetPosition = _get_position_from_packet(packet)
	cur.lastPing = 0
	cur.state = Cursor.cursorState.POINTING
	
func _create_cursor(packet: Dictionary) -> void:
	var isGrabbing : bool = packet["type"] == "drag" or packet["type"] == "click"
	var _position : Vector2 = _get_position_from_packet(packet)
	var newCursor : Cursor = cursorScene.instantiate()
	newCursor.userId = packet["id"]
	newCursor.state = Cursor.cursorState.GRABBING if isGrabbing else Cursor.cursorState.POINTING
	newCursor.targetPosition = _position
	newCursor.position = _position
	newCursor.deleteSelf.connect(_delete_cursor)
	cursors.set(packet["id"], newCursor)
	add_child(newCursor)

func _get_position_from_packet(packet: Dictionary) -> Vector2:
	return Vector2(packet["x"], packet["y"]) * get_tree().root.get_visible_rect().size

func _delete_cursor(cursor : Cursor) -> void:
	cursor.queue_free()
	cursors.erase(cursor.userId)
