extends Node

const STATE_FILE = "user://state.dat"

var current_level_time = 0

var music = preload("res://Music.tscn")
var music_instance = null

var state = {
	"level_times": {},
	"music_active": true,
	"mouse_active": false
}

var menu = preload("res://Main.tscn")

func is_music_active():
	if state.has("music_active"):
		return state["music_active"]

	return true

func is_mouse_active():
	if state.has("mouse_active"):
		return state["mouse_active"]

	return false

func set_music_active(active):
	state["music_active"] = active
	write_state()
	setup_music()

func set_mouse_active(active):
	state["mouse_active"] = active
	write_state()

func setup_music():
	if is_music_active() and not music_instance:
		music_instance = music.instance()
		add_child(music_instance)

	if not is_music_active() and music_instance:
		music_instance.queue_free()
		music_instance = null

func _ready():
	load_state()
	write_state()
	setup_music()

func load_state():
	var file = File.new()

	if file.file_exists(STATE_FILE):
		file.open(STATE_FILE, File.READ)
		state = file.get_var()
		file.close()
	else:
		print("loading default state...")

func write_state():
	var file = File.new()

	file.open(STATE_FILE, File.WRITE)
	file.store_var(state)
	file.close()

func reset_level_time(level_name):
	if state["level_times"].has(level_name):
		state["level_times"].erase(level_name)

	write_state()

func update_level_time(level_name, time):
	time = int(time)
	if state["level_times"].has(level_name):
		var current_best = state["level_times"][level_name]
		if time < current_best:
			state["level_times"][level_name] = time
	else:
		state["level_times"][level_name] = time

	write_state()

func get_level_time(level_name):
	if state["level_times"].has(level_name):
		return state["level_times"][level_name]

	return null
