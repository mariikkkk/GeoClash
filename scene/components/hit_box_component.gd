## Компонент хитбокса, наносящий урон при столкновении.[br]
## Хранит величину урона и предоставляет доступ к ней.
extends Area2D
class_name HitBoxComponent

## Урон, который наносит хитбокс.
var damage: int

## Возвращает нанесённый урон.
func get_damage() -> int:
	return damage
