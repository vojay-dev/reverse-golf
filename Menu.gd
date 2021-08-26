extends CanvasLayer

var game = preload("res://Minigolf.tscn")
var to_be_resetted = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$Control/CheckBox.pressed = Global.is_mouse_active()
	$Control/ActivateMusic.pressed = Global.is_music_active()
	Global.setup_music()

	if Global.music_instance:
		Global.music_instance.pitch_scale = 1

	_update_times()

func _update_times():
	var level1_best = Global.get_level_time("level_1")
	if level1_best:
		var level1_time = float(level1_best) / 100
		$Control/LevelContainer/GridContainer/BestTimeLabel1.text = "%.2f SECONDS" % level1_time
	else:
		$Control/LevelContainer/GridContainer/BestTimeLabel1.text = "no time yet"

	var level2_best = Global.get_level_time("level_2")
	if level2_best:
		var level2_time = float(level2_best) / 100
		$Control/LevelContainer/GridContainer/BestTimeLabel2.text = "%.2f SECONDS" % level2_time
	else:
		$Control/LevelContainer/GridContainer/BestTimeLabel2.text = "no time yet"

	var level3_best = Global.get_level_time("level_3")
	if level3_best:
		var level3_time = float(level3_best) / 100
		$Control/LevelContainer/GridContainer/BestTimeLabel3.text = "%.2f SECONDS" % level3_time
	else:
		$Control/LevelContainer/GridContainer/BestTimeLabel3.text = "no time yet"

func _physics_process(_delta):
	$Control/DialogBackground.visible = $Control/DialogContainer/ResetTimeDialog.visible

func _on_LevelButton1_pressed():
	Global.current_level_time = 0
	Global.current_level = Global.level1
	get_tree().change_scene_to(game)

func _on_LevelButton2_pressed():
	Global.current_level_time = 0
	Global.current_level = Global.level2
	get_tree().change_scene_to(game)

func _on_LevelButton3_pressed():
	Global.current_level_time = 0
	Global.current_level = Global.level3
	get_tree().change_scene_to(game)

func _on_CheckBox_toggled(button_pressed):
	Global.set_mouse_active(button_pressed)

func _on_ActivateMusic_toggled(button_pressed):
	Global.set_music_active(button_pressed)

func _on_DeleteTimeButton1_pressed():
	to_be_resetted = "level_1"
	$Control/DialogContainer/ResetTimeDialog.show()

func _on_DeleteTimeButton2_pressed():
	to_be_resetted = "level_2"
	$Control/DialogContainer/ResetTimeDialog.show()

func _on_DeleteTimeButton3_pressed():
	to_be_resetted = "level_3"
	$Control/DialogContainer/ResetTimeDialog.show()

func _on_ResetTimeDialog_confirmed():
	if to_be_resetted:
		Global.reset_level_time(to_be_resetted)
		to_be_resetted = null
		_update_times()
