extends Node2D
class_name Cursor

signal deleteSelf(cursor : Cursor)
enum cursorState {POINTING, GRABBING}
@export var sprites : Array[Texture2D]
@export var aliveTime : int = 120
@export_range(0.001, 1.0, 0.001) var smoothPositionSpeed = 0.25
@export_range(0.001, 1.0, 0.001) var smoothRotationSpeed = 0.175
@export var particleSpeedCap : float = 30
@export var maxRotation : float = 20
@export var particles : GPUParticles2D
@export var label : Label
@export var textureRect: TextureRect

var state : cursorState = cursorState.POINTING:
	set(value):
		state = value
		textureRect.texture = sprites[value]

var lastPing : float = 0:
	set(value):
		lastPing = value
		if value > aliveTime:
			deleteSelf.emit(self)

var userId : String:
	set(value):
		userId = value
		label.text = value
var targetPosition : Vector2 = Vector2.ZERO
var targetRotation : float = 0

func _physics_process(delta: float) -> void:
	lastPing += 1
	targetRotation = clamp((targetPosition - position).x, -maxRotation, maxRotation)
	if (targetPosition - position).length() > particleSpeedCap: particles.emitting = true 
	else: particles.emitting = false
	position = position.lerp(targetPosition, smoothPositionSpeed)
	textureRect.rotation_degrees = lerp(rotation_degrees, targetRotation, smoothRotationSpeed)
	label.rotation_degrees = -rotation_degrees
