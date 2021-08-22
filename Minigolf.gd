extends Spatial

var rotation_speed = 10
var rotation_speed_y = 5
var light_on = true

var prev_mouse_position = null

func _ready():
	$CanvasLayer/TimerLabel.text = str(Global.current_level_time)
	$Ball.apply_impulse(Vector3.ZERO, Vector3(0, 0, -2))

func _reset_control_colors():
	$CanvasLayer/Controls/Right.modulate = Color8(255, 255, 255)
	$CanvasLayer/Controls/Left.modulate = Color8(255, 255, 255)
	$CanvasLayer/Controls/Up.modulate = Color8(255, 255, 255)
	$CanvasLayer/Controls/Down.modulate = Color8(255, 255, 255)

func _physics_process(delta):
	_reset_control_colors()

	if Global.is_mouse_active():
		var current_mouse_position = get_viewport().get_mouse_position()

		if prev_mouse_position:
			var diff = prev_mouse_position - current_mouse_position
			$Level.rotation_degrees.z += diff.x * delta * 2
			$Level.rotation_degrees.x -= diff.y * delta * 2

		prev_mouse_position = current_mouse_position

	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to(Global.menu)

	if Input.is_action_pressed("right"):
		$Level.rotation_degrees.z -= rotation_speed * delta
		$CanvasLayer/Controls/Right.modulate = Color8(255, 93, 203)

	if Input.is_action_pressed("left"):
		$Level.rotation_degrees.z += rotation_speed * delta
		$CanvasLayer/Controls/Left.modulate = Color8(255, 93, 203)

	if Input.is_action_pressed("up"):
		$Level.rotation_degrees.x -= rotation_speed * delta
		$CanvasLayer/Controls/Up.modulate = Color8(255, 93, 203)

	if Input.is_action_pressed("down"):
		$Level.rotation_degrees.x += rotation_speed * delta
		$CanvasLayer/Controls/Down.modulate = Color8(255, 93, 203)

	$Level.rotation_degrees.z = clamp($Level.rotation_degrees.z, -8, 8)
	$Level.rotation_degrees.x = clamp($Level.rotation_degrees.x, -8, 8)
	
	_update_axis_meters()

	$Level.rotation_degrees.y += rotation_speed_y * delta

	$CanvasLayer/Controls.rect_rotation = -$Level.rotation_degrees.y

	$CanvasLayer/Controls/Right.rect_rotation = -$CanvasLayer/Controls.rect_rotation
	$CanvasLayer/Controls/Left.rect_rotation = -$CanvasLayer/Controls.rect_rotation
	$CanvasLayer/Controls/Up.rect_rotation = -$CanvasLayer/Controls.rect_rotation
	$CanvasLayer/Controls/Down.rect_rotation = -$CanvasLayer/Controls.rect_rotation

	$BallLight.translation.x = $Ball.translation.x
	$BallLight.translation.z = $Ball.translation.z

func _update_axis_meters():
	$CanvasLayer/AxisMeter1.rect_size.x = abs($Level.rotation_degrees.z * 8)
	$CanvasLayer/AxisMeter2.rect_size.x = abs($Level.rotation_degrees.x * 8)
	if $Level.rotation_degrees.z > 0:
		$CanvasLayer/AxisMeter1.rect_rotation = 180
	else:
		$CanvasLayer/AxisMeter1.rect_rotation = 0

	if $Level.rotation_degrees.x > 0:
		$CanvasLayer/AxisMeter2.rect_rotation = 90
	else:
		$CanvasLayer/AxisMeter2.rect_rotation = -90
	
	$CanvasLayer/AxisMeter1.color.g8 = 255
	$CanvasLayer/AxisMeter1.color.b8 = 255
	$CanvasLayer/AxisMeter1.color.g8 -= abs($Level.rotation_degrees.z * 18)
	$CanvasLayer/AxisMeter1.color.b8 -= abs($Level.rotation_degrees.z * 18)
	
	$CanvasLayer/AxisMeter2.color.g8 = 255
	$CanvasLayer/AxisMeter2.color.b8 = 255
	$CanvasLayer/AxisMeter2.color.g8 -= abs($Level.rotation_degrees.x * 18)
	$CanvasLayer/AxisMeter2.color.b8 -= abs($Level.rotation_degrees.x * 18)

func _on_Goal_body_entered(body):
	if body.is_in_group("ball"):
		Global.update_level_time("level_1", Global.current_level_time)
		get_tree().change_scene_to(Global.menu)

func _on_DayNightTimer_timeout():
	if light_on:
		_light_off()
	else:
		_light_on()

	$DayNightTween.start()

func _light_on():
	$DayNightTween.interpolate_property(
		$DirectionalLight,
		"light_energy",
		0,
		0.7,
		4,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)

	light_on = true

func _light_off():
	$DayNightTween.interpolate_property(
		$DirectionalLight,
		"light_energy",
		0.7,
		0,
		4,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)

	light_on = false

func _on_Ground_body_entered(body):
	if body.is_in_group("ball"):
		get_tree().reload_current_scene()

func _on_LevelTimer_timeout():
	Global.current_level_time += 1
	
	if Global.current_level_time % 200 == 0:
		_flash_timer()
	
	_set_time()

func _set_time():
	var time = float(Global.current_level_time) / 100
	$CanvasLayer/TimerLabel.text = "%.2f" % time

func _flash_timer():
	$CanvasLayer/AnimationPlayer.play("TimerHighlight")
