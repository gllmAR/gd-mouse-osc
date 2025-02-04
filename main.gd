# Main.gd
extends Node3D

# Sensitivity for mouse motion.
var sensitivity: float = 0.1
var pitch: float = 0.0
var yaw: float = 0.0
# Track the current mouse capture state.
var mouse_captured: bool = true

# Ensure these paths match your scene tree.
@onready var camera: Camera3D = $Camera
@onready var delta_label: Label = $UI/Panel/DeltaLabel
@onready var osc_client: OSCClient = $OSCClient  # Reference to the OSC client node

func _ready() -> void:
	# Initially capture the mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Debug message to verify the camera reference.
	if camera == null:
		print("Camera node not found!")
	else:
		print("Camera node found:", camera)

func _input(event: InputEvent) -> void:
	# Process mouse motion events.
	if event is InputEventMouseMotion and mouse_captured:
		var delta_x: float = event.relative.x
		var delta_y: float = event.relative.y

		# Update rotation values.
		yaw -= delta_x * sensitivity
		pitch -= delta_y * sensitivity

		# Update camera rotation.
		if camera:
			camera.rotation_degrees = Vector3(pitch, yaw, 0)
		
		# Update the UI label with the mouse delta.
		if delta_label:
			delta_label.text = "Mouse Delta: X = %s, Y = %s" % [str(delta_x), str(delta_y)]
		
		# Send OSC message with x and y deltas.
		if osc_client:
			osc_client.send_message("/mouse", [delta_x, delta_y])
	
	# Toggle mouse capture if the mapped key is pressed.
	if event.is_action_pressed("toggle_mouse_capture"):
		_toggle_mouse_capture()

## Toggles the mouse capture mode.
func _toggle_mouse_capture() -> void:
	mouse_captured = not mouse_captured
	if mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Mouse capture toggled. Captured:", mouse_captured)
