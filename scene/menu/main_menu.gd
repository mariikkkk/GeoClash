extends Control

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
@onready var start = $MainButtons/Start
@onready var settings = $MainButtons/Settings
@onready var exit = $MainButtons/Exit
@onready var options = $Options
@onready var main_buttons = $MainButtons
@onready var game_name = $GameName
@onready var figures = $Figures
<<<<<<< HEAD
=======
=======
@onready var start = $VBoxContainer/Start
@onready var settings = $VBoxContainer/Settings
@onready var exit = $VBoxContainer/Exit
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d

func _ready():
	start.pressed.connect(_on_start_pressed)
	settings.pressed.connect(_on_settings_pressed)
	exit.pressed.connect(_on_exit_pressed)
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
	options.visible = false
	figures.visible = true
	main_buttons.visible = true
	game_name.visible = true

func _on_start_pressed():
	UISoundManager.play_click()
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")
	
func _on_start_mouse_entered():
	UISoundManager.play_hover()
	
func _on_settings_pressed():
	print("Открывается меню настроек...")
	UISoundManager.play_click()
	options.visible = true
	figures.visible = false
	main_buttons.visible = false
	game_name.visible = false
	
func _on_settings_mouse_entered():
	UISoundManager.play_hover()

func _on_exit_pressed():
	UISoundManager.play_click()
	get_tree().quit()

func _on_exit_mouse_entered():
	UISoundManager.play_hover()

func _on_back_pressed():
	UISoundManager.play_click()
	options.visible = false
	figures.visible = true
	main_buttons.visible = true
	game_name.visible = true

func _on_back_mouse_entered():
	UISoundManager.play_hover()
<<<<<<< HEAD
=======
=======

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")

func _on_settings_pressed():
	print("Открывается меню настроек...")

func _on_exit_pressed():
	get_tree().quit()
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
