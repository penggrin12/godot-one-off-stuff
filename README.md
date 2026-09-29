# Quickstart

```gdscript
func on_button_pressed() -> void:
	Audio.play(ui_sound)
```

```gdscript
func shoot() -> void:
	Audio.play_from(shoot_sound, $Gun)

	var ray := Ray3D.cast_as($Gun, 150)
	if not ray.has_hit():
		return

	Audio.play3d(bullet_impact_sound, ray.position)
	apply_impact_decal(ray.position, ray.normal)
	damage(ray.collider)
```

# Simple API reference

> [!NOTE]
> See Godot's F1 help page for way more details.

## `Audio`
- Static `play`, `play2d`, `play3d`, and `play_from`.

## `Ray3D`
- Static `cast` and `cast_as` returning a `Ray3D` instance.
- Non-static `is_hit` returning `bool`.
- A whole bunch of properties (`collider`, `position`, `normal`, ...).
