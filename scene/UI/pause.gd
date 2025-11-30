## Меню паузы.[br]
## Ставит игру на паузу и позволяет продолжить, перезапустить уровень или выйти в меню.
extends CanvasLayer
class_name PauseMenu

## Активирует паузу при открытии меню.
func _ready():
	get_tree().paused = true


## Продолжает игру и скрывает меню.
func _on_resume_pressed():
	UISoundManager.play_click()
	get_tree().paused = false
	visible = false


## Перезапускает текущий уровень.
func _on_restart_pressed():
	UISoundManager.play_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")


## Выходит в главное меню.
func _on_quit_pressed():
	UISoundManager.play_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")


## Звук наведения для кнопки "Продолжить".
func _on_resume_mouse_entered():
	UISoundManager.play_hover()


## Звук наведения для кнопки "Перезапуск".
func _on_restart_mouse_entered():
	UISoundManager.play_hover()


## Звук наведения для кнопки "Выход".
func _on_quit_mouse_entered():
	UISoundManager.play_hover()
