extends Node2D
class_name SwordAttackAbility

@onready var hit_box_component: HitBoxComponent = $HitBoxComponent

func _ready():
	add_to_group("sword_attack")
