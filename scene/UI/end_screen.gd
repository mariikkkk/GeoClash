## Экран завершения игры.[br]
## Ставит игру на паузу и предоставляет кнопки перезапуска или выхода в меню.
extends CanvasLayer
class_name EndScreen

## Активирует паузу при открытии экрана.
func _ready():
	get_tree().paused = true


## Перезапускает уровень.
##
## Воспроизводит звук нажатия и снимает паузу.
func _on_restart_pressed():
	UISoundManager.play_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")


## Переходит в главное меню.
##
## Воспроизводит звук нажатия и снимает паузу.
func _on_quit_pressed():
	UISoundManager.play_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu/main_menu.tscn")


## Проигрывает звук наведения для кнопки перезапуска.
func _on_restart_mouse_entered():
	UISoundManager.play_hover()


## Проигрывает звук наведения для кнопки выхода.
func _on_quit_mouse_entered():
	UISoundManager.play_hover()
