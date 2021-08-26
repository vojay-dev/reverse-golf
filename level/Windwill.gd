extends Spatial

func _physics_process(delta):
	$tmpParent/windmill2/blades.rotation_degrees.z += delta * 100
