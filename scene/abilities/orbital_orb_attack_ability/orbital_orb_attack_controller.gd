## Контроллер орбитальных атак.[br]
## Создаёт орбы вокруг игрока и вращает их с заданной скоростью.
class_name OrbAttackController
extends Node

## Сцена орба.
@export var orb_scene: PackedScene

## Количество орбов.
@export var orb_count: int = 1

## Радиус орбиты.
@export var orbit_radius: float = 80.0

## Скорость вращения орбов.
@export var rotation_speed: float = 6.0

## Урон одного орба.
@export var orb_damage: float = 1


## Игрок, вокруг которого вращаются орбы.
var _player: Node2D

## Список активных орбов.
var _orbs: Array[OrbAttackAbility] = []

## Базовые углы расположения орбов.
var _base_angles: Array[float] = []

## Смещение угла для вращения.
var _angle_offset: float = 0.0


## Инициализация: находит игрока и создаёт орбы.
func _ready():
	_player = get_tree().get_first_node_in_group("player") as Node2D
	if _player == null:
		push_warning("Игрок не найден!")
		return
	
	rebuild_orbs()
	call_deferred("_update_orb_position")


## Обновляет вращение орбов каждый кадр.
##
## [param delta] — время кадра.
func _process(delta):
	if _player == null:
		return
	
	_angle_offset += rotation_speed * delta
	_update_orb_position()


## Обновляет позиции и углы всех орбов вокруг игрока.[br]
##
## Логика:[br]
## - получает позицию игрока;[br]
## - вычисляет итоговый угол каждого орба;[br]
## - размещает орбы по окружности;[br]
## - задаёт им поворот.
func _update_orb_position():
	if _player == null:
		return
		
	var center := _player.global_position
	
	for i in _orbs.size():
		var angle := _base_angles[i] + _angle_offset
		var offset := Vector2(cos(angle), sin(angle)) * orbit_radius
		_orbs[i].global_position = center + offset
		_orbs[i].rotation = angle


## Полностью пересоздаёт орбы с учётом их количества и урона.[br]
##
## Логика:[br]
## - удаляет старые орбы;[br]
## - очищает списки углов;[br]
## - создаёт новые орбы и задаёт им базовый угол;[br]
## - вызывает обновление позиции после создания.
func rebuild_orbs():
	for orb in _orbs:
		orb.queue_free()
	_orbs.clear()
	_base_angles.clear()

	if _player == null:
		return

	for i in orb_count:
		var orb = orb_scene.instantiate() as OrbAttackAbility
		_player.call_deferred("add_child", orb)
		orb.set_damage(orb_damage)
		_orbs.append(orb)

		var base_angle := float(i) / float(orb_count) * TAU
		_base_angles.append(base_angle)

	call_deferred("_update_orb_position")
