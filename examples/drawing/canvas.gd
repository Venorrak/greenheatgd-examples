extends TextureRect

@export var colorPickers : Array[colorPicker]
@export var defaultColor : Color
var currentImg : Image
var brushSize : int = 3
var brushColor : Dictionary[String, Color] = {}

func _ready() -> void:
	texture = ImageTexture.create_from_image(Image.create_empty(600, 400, false, Image.FORMAT_RGBA8))
	currentImg = texture.get_image()
	for c in colorPickers:
		c.userColorChanged.connect(_user_color_changed)
		
func _gui_input(event: InputEvent) -> void:
	if not GreenHeat.is_input_heat(event): return
	print(event)
	if event is InputEventMouse && (event.button_mask == 1 || event.button_mask == 2):
		var cursorPosition : Vector2 = event.position
		var userId : String = GreenHeat.get_id(event)
		if not brushColor.has(userId): _user_color_changed(userId, defaultColor)
		if event is InputEventMouseMotion:
			if event.relative.length_squared() > 0:
				var n : int = ceili(event.relative.length())
				var lastPos : Vector2 = cursorPosition - event.relative
				for i in n:
					cursorPosition = cursorPosition.move_toward(lastPos, 1.0)
					if event.button_mask == 1:
						_brush_at(cursorPosition, brushColor[userId])
					elif event.button_mask == 2:
						_erase_at(cursorPosition)
				texture.update(currentImg)
		if event is InputEventMouseButton:
			if event.button_mask == 1:
				_brush_at(cursorPosition, brushColor[userId])
			elif event.button_mask == 2:
				_erase_at(cursorPosition)
			texture.update(currentImg)
	
func _brush_at(_position: Vector2, color: Color) -> void:
	currentImg.fill_rect(Rect2(_position, Vector2(1, 1)).grow(brushSize), color)

func _erase_at(_position: Vector2) -> void:
	currentImg.fill_rect(Rect2(_position, Vector2(1, 1)).grow(brushSize), Color.TRANSPARENT)

func _user_color_changed(id: String, color: Color) -> void:
	brushColor.set(id, color)
