extends Spatial

func _on_Timer_timeout():
	$AnimationPlayer.play("Rotate")
