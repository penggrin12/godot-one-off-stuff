## Casts one-off 3D rays without using [RayCast3D].
##
## [b]Note:[/b] This class is not meant to be instantiated manually.
##              Use [method cast] or [method cast_as] instead.
class_name Ray3D extends RefCounted

## By default, all collision layers are detected. See
## [url=https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html#collision-layers-and-masks]Collision layers and masks[/url]
## in the documentation for more information.
const DEFAULT_COLLISION_MASK := 0xFFFFFFFF

## The colliding object. Typically (but not always) a subclass of [CollisionObject3D].
var collider: Object = null
## The object's surface normal at the intersection point.
var normal: Vector3
## The intersection point in global 3D space.
var position: Vector3
## The face index at the intersection point.
var face_index: int
## The intersecting object's [RID].
var rid: RID
## The shape index of the colliding shape.
var shape: int


## Returns [code]true[/code] if the ray has intersected with something.
##
## Equivalent to [code]collider != null[/code].
func has_hit() -> bool:
	return collider != null


func _to_string() -> String:
	return "<Ray3D %s => %s>" % [position, normal] if has_hit() else "<Ray3D>"


static func _obj_to_rid(obj) -> RID:
	if obj is RID:
		return obj
	if obj is CollisionObject3D:
		return obj.get_rid()

	assert(
		false,
		'"%s" was passed to Ray3D.cast in exclude, but its not a RID or a CollisionObject3D.' % obj,
	)
	return RID() # silencing an error. should be unreachable.


## Manually casts a 3D ray with a maximum length of [param distance],
## starting from [param origin], facing normalized [param direction].
##
## If the ray did not intersect anything,
## its [member collider] will be [code]null[/code],
## and [method has_hit] will return [code]false[/code].
##
## [param exclude] can contain instances of either [CollisionObject3D] or [RID].
##
## This method avoids using the [RayCast3D] node.
## [url=https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html]Read more[/url].
static func cast(
	origin: Vector3,
	direction: Vector3,
	distance: float,
	collision_mask: int = DEFAULT_COLLISION_MASK,
	exclude: Array = [],
) -> Ray3D:
	var tree := Engine.get_main_loop() as SceneTree
	var dss := tree.root.world_3d.direct_space_state

	var query := PhysicsRayQueryParameters3D.create(
		origin,
		origin + direction.normalized() * distance,
		collision_mask,
		exclude.map(_obj_to_rid),
	)
	var data := dss.intersect_ray(query)

	var result = Ray3D.new()
	if not data.is_empty():
		result.collider = data["collider"]
		result.position = data["position"]
		result.normal = data["normal"]
		result.face_index = data["face_index"]
		result.rid = data["rid"]
		result.shape = data["shape"]
	return result


## Manually casts a 3D ray with a maximum length of [param distance],
## starting from the given [param node]'s origin and orientation.
##
## If [param try_excluding_node] is [code]true[/code],
## and [param node] is a subclass of [CollisionObject3D],
## internally duplicates [param exclude] and adds [param node] to the end of it.
##
## See [method cast] for more information.
static func cast_as(
	node: Node3D,
	distance: float,
	collision_mask: int = DEFAULT_COLLISION_MASK,
	exclude: Array = [],
	try_excluding_node: bool = true,
) -> Ray3D:
	if try_excluding_node and (node is CollisionObject3D):
		# prevent modifying the original
		exclude = exclude.duplicate()
		exclude.push_back(node)
	return cast(node.global_position, -node.global_basis.z, distance, collision_mask, exclude)
