## Таймер, отображающий время выживания игрока.[br]
## Получает время у внешнего менеджера и выводит его в формате ММ:СС.
class_name TimerUI
extends CanvasLayer

## Менеджер времени арены.
@export var arena_time_manager: Node 

## Текстовое поле с таймером.
@onready var time = %Time


## Обновляет таймер каждую игру (каждый кадр).[br]
##
## [param _delta] — время кадра.
func _process(_delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	time.text = format_timer(time_elapsed)


## Форматирует секунды в строку ММ:СС.
##
## [param seconds] — количество секунд.
func format_timer(seconds: float):
	var minutes = floor(seconds / 60)
	var remaning_seconds = seconds - (minutes * 60)
	return str(int(minutes)) + ":" + "%02d" % floor(int(remaning_seconds))
