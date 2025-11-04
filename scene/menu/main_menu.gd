extends Control

@onready var start = $VBoxContainer/Start
@onready var settings = $VBoxContainer/Settings
@onready var exit = $VBoxContainer/Exit

func _ready():
	start.pressed.connect(_on_start_pressed)
	settings.pressed.connect(_on_settings_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")

func _on_settings_pressed():
	print("Открывается меню настроек...")

func _on_exit_pressed():
	get_tree().quit()
