## Plays one-off audio samples without instantiating [AudioStreamPlayer] nodes yourself.
##
## [b]Note:[/b] This is a static utility class, and it should not be inherited from.
##              Instead, use one of the static methods.
@abstract
class_name Audio extends RefCounted

## The default audio bus name used when none is provided.
const DEFAULT_BUS := &"Master"


# player is AudioStreamPlayer, AudioStreamPlayer2D, or AudioStreamPlayer3D.
static func _setup(
	player: Node,
	stream: AudioStream,
	bus: StringName,
	volume_db: float,
	pitch_scale: float,
	position: Variant = null,
) -> Node:
	player.stream = stream
	player.bus = bus
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	if position != null:
		player.position = position

	return player


# player is AudioStreamPlayer, AudioStreamPlayer2D, or AudioStreamPlayer3D.
static func _do_work(player: Node, parent: Node = null) -> void:
	if parent == null:
		parent = (Engine.get_main_loop() as SceneTree).root

	parent.add_child(player)
	#await player.tree_entered
	player.play()
	await player.finished
	player.queue_free()


## Plays an [AudioStream] globally.
static func play(
	stream: AudioStream,
	bus: StringName = DEFAULT_BUS,
	volume_db: float = 0.0,
	pitch_scale: float = 1.0,
) -> void:
	_do_work(_setup(AudioStreamPlayer.new(), stream, bus, volume_db, pitch_scale, null))


## Plays an [AudioStream] at the specified 2D point.
static func play2d(
	stream: AudioStream,
	position: Vector2,
	bus: StringName = DEFAULT_BUS,
	volume_db: float = 0.0,
	pitch_scale: float = 1.0,
) -> void:
	_do_work(_setup(AudioStreamPlayer2D.new(), stream, bus, volume_db, pitch_scale, position))


## Plays an [AudioStream] at the specified 3D point.
static func play3d(
	stream: AudioStream,
	position: Vector3,
	bus: StringName = DEFAULT_BUS,
	volume_db: float = 0.0,
	pitch_scale: float = 1.0,
) -> void:
	_do_work(_setup(AudioStreamPlayer3D.new(), stream, bus, volume_db, pitch_scale, position))


## Uses an [AudioStreamPlayer2D] or [AudioStreamPlayer3D]
## to play an [AudioStream], tracking [param target]'s position.
static func play_from(
	stream: AudioStream,
	target: Node,
	bus: StringName = DEFAULT_BUS,
	volume_db: float = 0.0,
	pitch_scale: float = 1.0,
) -> void:
	var node_type
	if target is Node2D:
		node_type = AudioStreamPlayer2D
	elif target is Node3D:
		node_type = AudioStreamPlayer3D
	else:
		assert(false, "The target node must be a descendant of either Node2D or Node3D.")

	_do_work(_setup(node_type.new(), stream, bus, volume_db, pitch_scale, null), target)
