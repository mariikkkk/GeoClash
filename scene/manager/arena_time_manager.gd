## Менеджер времени арены.[br]
## Отслеживает, сколько секунд прошло с начала раунда.
class_name ArenaTimeManager
extends Node

## Таймер, отсчитывающий время раунда.
@onready var timer = $Timer


## Возвращает количество прошедших секунд.
##
## [param none] — использует внутренний Timer.
##
## Принцип:[br]
## wait_time - time_left = прошедшее время.
func get_time_elapsed():
	return timer.wait_time - timer.time_left
