extends Spatial

var rotation_speed_y = 5

func _ready():
	update_level_background()

func _physics_process(delta):
	$Level.rotation_degrees.z = clamp($Level.rotation_degrees.z, -8, 8)
	$Level.rotation_degrees.x = clamp($Level.rotation_degrees.x, -8, 8)

	$Level.rotation_degrees.y += rotation_speed_y * delta

func update_level_background():
	if has_node("Level"):
		$Level.queue_free()
		remove_child($Level)

	var level = Global.current_level.instance()
	level.set_name("Level")
	add_child(level)

func _on_Menu_active_level_changed():
	update_level_background()
