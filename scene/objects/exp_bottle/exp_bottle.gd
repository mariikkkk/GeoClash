## Бутылка опыта, которую можно подобрать.[br]
## При попадании в зону игрока передаёт количество опыта и удаляется.
extends Node2D
class_name ExpBottle


## Количество получаемого опыта.
var bottle_exp = 1


## Передаёт опыт глобальному сигналу и удаляет бутылку.
##
## [param _area] — область, вошедшая в коллизию (не используется).
func _on_area_2d_area_entered(_area):
	Global.exp_bottle_collected.emit(bottle_exp)
	queue_free()
