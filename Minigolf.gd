extends Spatial

var mouse_sensitivity = 0.006
var rotation_speed = 10
var rotation_speed_y = 5

var light_on = true
var reached_goal = false

var zoom
var goal

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	$CanvasLayer/TimerLabel.text = str(Global.current_level_time)
	zoom = $CameraPivot/InterpolatedCamera.translation.y

	var level = Global.current_level.instance()
	level.set_name("Level")
	add_child(level)

	var spawn = $Level.find_node("Spawn")
	$Ball.translation = spawn.translation
	$Ball.apply_impulse(Vector3.ZERO, Vector3(0, 0, -2))

	goal = $Level.find_node("Goal")
	goal.connect("body_entered", self, "_on_Goal_body_entered")

func _reset_control_colors():
	$CanvasLayer/Controls/Right.modulate = Color8(255, 255, 255)
	$CanvasLayer/Controls/Left.modulate = Color8(255, 255, 255)
	$CanvasLayer/Controls/Up.modulate = Color8(255, 255, 255)
	$CanvasLayer/Controls/Down.modulate = Color8(255, 255, 255)

func _set_music_pitch():
	var goal_origin = goal.global_transform.origin
	var distance = $Ball.global_transform.origin.distance_to(goal_origin)

	if Global.music_instance:
		if distance < 1:
			Global.music_instance.pitch_scale = distance
		elif Global.music_instance.pitch_scale < 1:
			Global.music_instance.pitch_scale = 1

func _input(event):
	if event is InputEventMouseMotion:
		$CameraPivot.rotation_degrees.y += -event.relative.x * mouse_sensitivity * 10

	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				_zoom_in()
			if event.button_index == BUTTON_WHEEL_DOWN:
				_zoom_out()

func _zoom_in():
	zoom -= .1
	zoom = clamp(zoom, 1.5, 7)
	_transition_zoom()

func _zoom_out():
	zoom += .1
	zoom = clamp(zoom, 1.5, 7)
	_transition_zoom()

func _transition_zoom():
	var initial_val = $CameraPivot/InterpolatedCamera.translation.y

	var current_translation = $CameraPivot/InterpolatedCamera.translation
	var target = Vector3(current_translation.x, zoom, zoom)

	$CameraPivot/Tween.interpolate_property($CameraPivot/InterpolatedCamera, "translation", current_translation, target, .2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$CameraPivot/Tween.start()

func _physics_process(delta):
	if reached_goal:
		return

	_set_music_pitch()
	_reset_control_colors()

	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to(Global.menu)

	if Input.is_action_pressed("right"):
		$Level.rotation_degrees.z -= rotation_speed * delta
		$CanvasLayer/Controls/Right.modulate = Color8(0, 201, 255)

	if Input.is_action_pressed("left"):
		$Level.rotation_degrees.z += rotation_speed * delta
		$CanvasLayer/Controls/Left.modulate = Color8(0, 201, 255)

	if Input.is_action_pressed("up"):
		$Level.rotation_degrees.x -= rotation_speed * delta
		$CanvasLayer/Controls/Up.modulate = Color8(0, 201, 255)

	if Input.is_action_pressed("down"):
		$Level.rotation_degrees.x += rotation_speed * delta
		$CanvasLayer/Controls/Down.modulate = Color8(0, 201, 255)

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
		$LevelTimer.stop()
		Global.update_level_time($Level.level_identifier, Global.current_level_time)

		reached_goal = true
		$Ball.queue_free()

		$GoalSound.play()

func _on_GoalSound_finished():
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
		$FallDownSound.play()

func _on_FallDownSound_finished():
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
