extends CanvasLayer

var level1 = preload("res://Minigolf.tscn")

var to_be_resetted = null

func _ready():
	$Control/CheckBox.pressed = Global.is_mouse_active()
	$Control/ActivateMusic.pressed = Global.is_music_active()
	Global.setup_music()

	_update_times()

func _update_times():
	var level1_best = Global.get_level_time("level_1")
	if level1_best:
		var level1_time = float(level1_best) / 100
		$Control/LevelContainer/GridContainer/BestTimeLabel1.text = "%.2f SECONDS" % level1_time
	else:
		$Control/LevelContainer/GridContainer/BestTimeLabel1.text = "no time yet"

func _physics_process(delta):
	$Control/DialogBackground.visible = $Control/DialogContainer/ResetTimeDialog.visible

func _on_LevelButton1_pressed():
	Global.current_level_time = 0
	get_tree().change_scene_to(level1)

func _on_CheckBox_toggled(button_pressed):
	Global.set_mouse_active(button_pressed)

func _on_ActivateMusic_toggled(button_pressed):
	Global.set_music_active(button_pressed)

func _on_DeleteTimeButton1_pressed():
	to_be_resetted = "level_1"
	$Control/DialogContainer/ResetTimeDialog.show()

func _on_ResetTimeDialog_confirmed():
	if to_be_resetted:
		Global.reset_level_time(to_be_resetted)
		to_be_resetted = null
		_update_times()
