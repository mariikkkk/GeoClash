## Компонент получения урона.[br]
## При столкновении с HitBoxComponent наносит урон своему HealthComponent.
extends Area2D
class_name HurtBoxComponent

## Компонент здоровья, которому передаётся урон.
@export var health_component: HealthComponent


## Обрабатывает входящий хитбокс и наносит урон.
##
## [param area] — столкнувшаяся область.
func _on_area_entered(area: Area2D):
	if not area is HitBoxComponent:
		return
	if health_component == null:
		return

	var hit_box_component = area as HitBoxComponent
	health_component.take_damage(hit_box_component.damage)
