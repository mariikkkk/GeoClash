extends CanvasLayer
class_name EndScreen

func _ready():
	get_tree().paused = true
<<<<<<< HEAD
	

func _on_restart_pressed():
	UISoundManager.play_click()
=======

func _on_restart_pressed():
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")


func _on_quit_pressed():
<<<<<<< HEAD
	UISoundManager.play_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")


func _on_restart_mouse_entered():
	UISoundManager.play_hover()


func _on_quit_mouse_entered():
	UISoundManager.play_hover()
=======
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
