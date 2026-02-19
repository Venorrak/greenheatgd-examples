extends Node2D
class_name Cursor

signal deleteSelf(cursor : Cursor)
enum cursorState {POINTING, GRABBING}
@export var sprites : Array[Texture2D]
@export var aliveTime : int = 120
@export_range(0.001, 1.0, 0.001) var smoothPositionSpeed = 0.25
@export_range(0.001, 1.0, 0.001) var smoothRotationSpeed = 0.175
@export var maxRotation : float = 100
@export var particles : GPUParticles2D
@export var label : Label
@export var textureRect: TextureRect

var state : cursorState = cursorState.POINTING:
	set(value): # when the value of state changes we update the sprite
		state = value
		textureRect.texture = sprites[value]

var lastPing : float = 0:
	set(value):
		lastPing = value
		if value > aliveTime: # ask parent to kill us if we are too old
			deleteSelf.emit(self)

var userId : String:
	set(value): # if usedId is changed change the current diplayed name
		userId = value
		label.text = value
var targetPosition : Vector2 = Vector2.ZERO
var targetRotation : float = 0

func _physics_process(delta: float) -> void:
	lastPing += 1
	targetRotation = clamp((targetPosition - position).x, -maxRotation, maxRotation) #get target rotation from horizontal speed 
	
	position = position.lerp(targetPosition, smoothPositionSpeed) # lerp towards target
	textureRect.rotation_degrees = lerp(rotation_degrees, targetRotation, smoothRotationSpeed) # lerp rotation to target
