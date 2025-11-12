extends Node

@export var drop_percent = 0.4
@export var exp_bottle1: PackedScene
@onready var health_component: HealthComponent = get_parent().get_node_or_null("HealthComponent")

func _ready():
	health_component.died.connect(on_died)

func on_died():
	if randf() >= drop_percent:
		return
	if exp_bottle1 == null:
		return
	if not owner is Node2D:
		return
	var spawn_pos = (owner as Node2D).global_position
	var exp_bottle_instance = exp_bottle1.instantiate() as Node2D
	owner.get_parent().add_child(exp_bottle_instance)
	exp_bottle_instance.global_position = spawn_pos
