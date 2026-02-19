extends Node2D

@export var greenHeat : GreenHeat
@export var particles : GPUParticles2D

func _ready() -> void:
	greenHeat.click_received.connect(_on_click)
	
func _on_click(packet: Dictionary) -> void:
	particles.position = Vector2(packet["x"], packet["y"]) * Vector2(600, 400) # move GpuParciles generator
	particles.emit_particle( # create a particle (the red circle)
		Transform2D(0, Vector2(0, 0)),
		Vector2.ZERO,
		Color.WHITE,
		Color.WHITE,
		0
	)
