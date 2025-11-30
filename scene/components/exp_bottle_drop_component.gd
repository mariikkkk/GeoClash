## Компонент выпадения бутылки опыта после смерти врага.[br]
## С заданной вероятностью создаёт объект опыта на позиции врага.
extends Node
class_name ExpBottleDropComponent

## Вероятность дропа (0.0–1.0).
@export var drop_percent = 0.4

## Сцена бутылки опыта.
@export var exp_bottle1: PackedScene

## Компонент здоровья родителя.
@onready var health_component: HealthComponent = get_parent().get_node_or_null("HealthComponent")


## Подписывается на смерть родителя.
func _ready():
	health_component.died.connect(on_died)


## Создаёт бутылку опыта, если сработал шанс выпадения.
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
