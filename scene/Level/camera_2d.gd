## Камера, следящая за игроком и создающая эффект тряски.[br]
## При вызове shake() временно смещает камеру в случайном направлении. 
extends Camera2D
class_name PlayerCamera

## Ссылка на игрока.
@onready var player = $"../player"

## Сила тряски камеры.
@export var shake_amount := 6.0

## Оставшееся время тряски.
var t := 0.0


## Запускает тряску камеры.
##
## [param time] — длительность эффекта.
func shake(time := 0.1):
	t = time


## Обновляет позицию камеры и применяет тряску.
##
## [param delta] — время кадра.
func _process(delta):
	if player == null:
		return

	if t > 0.0:
		t -= delta
		offset = Vector2(randf() - 0.5, randf() - 0.5) * shake_amount
	else:
		offset = Vector2.ZERO

	global_position = player.global_position
