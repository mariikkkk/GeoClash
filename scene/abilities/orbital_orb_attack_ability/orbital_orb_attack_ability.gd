extends Node2D
class_name OrbAttackAbility

func set_damage(value: int):
	var hit_box_component = $HitBoxComponent
	hit_box_component.damage = value
