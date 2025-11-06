extends CanvasLayer
class_name EndScreen

func _ready():
	get_tree().paused = true

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")
