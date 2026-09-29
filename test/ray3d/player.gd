extends Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"test_cast"):
		_cast()
		return
	if event is InputEventMouseMotion:
		_player_rotation(-event.relative * 0.01)
		return


func _cast() -> void:
	print(Ray3D.cast_as(self, 10))


func _player_rotation(mouse_motion: Vector2) -> void:
	rotate_y(mouse_motion.x)
	rotate_x(mouse_motion.y)
	#rotation_degrees.x = clampf(rotation_degrees.x, -80.0, 80.0)
	rotation.z = 0
