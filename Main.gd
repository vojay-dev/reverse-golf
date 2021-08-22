extends Spatial

"""
MUSIC ATTRIBUTION:

Monkeys Spinning Monkeys Kevin MacLeod (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0 License
http://creativecommons.org/licenses/by/3.0/
Music promoted by https://www.chosic.com/
"""

var rotation_speed_y = 5

func _physics_process(delta):
	$Level.rotation_degrees.z = clamp($Level.rotation_degrees.z, -8, 8)
	$Level.rotation_degrees.x = clamp($Level.rotation_degrees.x, -8, 8)
	
	$Level.rotation_degrees.y += rotation_speed_y * delta
