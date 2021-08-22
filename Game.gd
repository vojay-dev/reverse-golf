extends Node2D

var rotation_speed = 100

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		$World.rotation_degrees -= rotation_speed * delta

	if Input.is_action_pressed("right"):
		$World.rotation_degrees += rotation_speed * delta

func _on_Area2D_body_entered(body):
	get_tree().reload_current_scene()

func _on_ImpulseTimer_timeout():
	$Ball.apply_impulse(Vector2.ZERO, Vector2(100, 0))

func _on_Laser_body_entered(body):
	get_tree().reload_current_scene()
