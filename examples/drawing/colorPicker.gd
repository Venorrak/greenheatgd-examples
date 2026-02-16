extends ColorRect
class_name colorPicker

signal userColorChanged(id: String, _color: Color)

func _gui_input(event: InputEvent) -> void:
	if GreenHeat.is_input_heat(event) && event is InputEventMouseButton && event.is_pressed():
		userColorChanged.emit(GreenHeat.get_id(event), color)
