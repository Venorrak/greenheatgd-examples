extends TextureRect

@export var colorPickers : Array[colorPicker]
@export var defaultColor : Color
@export var brushSize : int = 3

var currentImg : Image
var brushColor : Dictionary[String, Color] = {} # bush color for each twitchid

func _ready() -> void:
	texture = ImageTexture.create_from_image(Image.create_empty(600, 400, false, Image.FORMAT_RGBA8))
	currentImg = texture.get_image()
	
	for c in colorPickers:
		c.userColorChanged.connect(_user_color_changed)
		
func _gui_input(event: InputEvent) -> void: # function called when the control node is interacted with
	if not GreenHeat.is_input_heat(event): return # If not greenheat return
	if event is InputEventMouse && (event.button_mask == 1 || event.button_mask == 2): # if it's a mouse input & it's a right or left click
		var cursorPosition : Vector2 = event.position
		var userId : String = GreenHeat.get_id(event)
		if not brushColor.has(userId): _user_color_changed(userId, defaultColor) # if the user has not yet chosen a color set it to default color
		if event is InputEventMouseMotion: # drag
			if event.relative.length_squared() > 0: # this next block is to draw a line between the current and last position of the cursor
				var n : int = ceili(event.relative.length())
				var lastPos : Vector2 = cursorPosition - event.relative
				for i in n:
					cursorPosition = cursorPosition.move_toward(lastPos, 1.0)
					if event.button_mask == 1:
						_brush_at(cursorPosition, brushColor[userId])
					elif event.button_mask == 2:
						_erase_at(cursorPosition)
				texture.update(currentImg)

		if event is InputEventMouseButton: #click
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
