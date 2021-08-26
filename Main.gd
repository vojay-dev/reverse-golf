extends Spatial

var rotation_speed_y = 5

func _physics_process(delta):
	$Level.rotation_degrees.z = clamp($Level.rotation_degrees.z, -8, 8)
	$Level.rotation_degrees.x = clamp($Level.rotation_degrees.x, -8, 8)
	
	$Level.rotation_degrees.y += rotation_speed_y * delta
