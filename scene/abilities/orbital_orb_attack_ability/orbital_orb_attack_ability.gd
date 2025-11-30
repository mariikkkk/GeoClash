## Способность атаки орбом.[br]
## Позволяет задать урон орба через внутренний HitBoxComponent.
class_name OrbAttackAbility
extends Node2D


## Устанавливает урон орба.
##
## [param value] — новое значение урона.
func set_damage(value: float):
	var hit_box_component = $HitBoxComponent
	hit_box_component.damage = value
