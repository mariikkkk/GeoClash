extends CanvasLayer
class_name PauseMenu

func _ready():
	get_tree().paused = true

func _on_resume_pressed():
<<<<<<< HEAD
	UISoundManager.play_click()
=======
<<<<<<< HEAD
	UISoundManager.play_click()
=======
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
	get_tree().paused = false
	visible = false
	
func _on_restart_pressed():
<<<<<<< HEAD
	UISoundManager.play_click()
=======
<<<<<<< HEAD
	UISoundManager.play_click()
=======
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")

func _on_quit_pressed():
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
	UISoundManager.play_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")
	


func _on_resume_mouse_entered():
	UISoundManager.play_hover()


func _on_restart_mouse_entered():
	UISoundManager.play_hover()


func _on_quit_mouse_entered():
	UISoundManager.play_hover()
<<<<<<< HEAD
=======
=======
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")
	
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
