## Контроллер атаки мечом.[br]
## Периодически создаёт мечи и направляет их в ближайших врагов.
class_name AttackController
extends Node

## Сцена способности атаки.
@export var attack_abillity: PackedScene

## Максимальная дистанция поиска врагов.
@export var attack_range: float = 200.0

## Урон одного меча.
@export var sword_damage: int = 5

## Максимальное количество одновременно активных мечей.
@export var max_swords: int = 3

## Масштаб меча.
@export var sword_scale: float = 1.5

## Время между атаками.
@export var attack_cooldown: float = 1.0

## Таймер для запуска атаки.
@onready var _timer: Timer = $Timer


## Настраивает интервал таймера и запускает его.
func _ready() -> void:
	_timer.wait_time = attack_cooldown
	_timer.start()


## Создаёт меч и размещает его перед выбранным врагом.[br]
##
## [param player] — игрок.[br]
## [param player_pos] — позиция игрока.[br]
## [param enemy] — целевой враг.
func spawn_sword(player: Node2D, player_pos: Vector2, enemy: Node2D):
	var enemy_pos = enemy.global_position
	var attack_instance = attack_abillity.instantiate() as SwordAttackAbility
	player.get_parent().add_child(attack_instance)

	attack_instance.hit_box_component.damage = sword_damage
	attack_instance.scale = Vector2.ONE * sword_scale

	var dir = (enemy_pos - player_pos).normalized()
	var offset: float = 50.0
	attack_instance.global_position = enemy_pos - dir * offset
	attack_instance.look_at(enemy_pos)


## Обрабатывает цикл атаки и создаёт мечи, направленные в ближайших врагов.[br]
##
## Логика работы:[br]
## 1) Находит игрока и его позицию.[br]
## 2) Проверяет текущее количество мечей в группе "sword_attack".[br]
##    Если достигнут максимум — выход.[br]
## 3) Находит всех врагов в группе "enemy".[br]
## 4) Фильтрует их по радиусу атаки [param attack_range].[br]
## 5) Сортирует врагов по расстоянию до игрока (самые близкие — первыми).[br]
## 6) Выбирает уникальные цели, не повторяя одного и того же врага в одном цикле.[br]
## 7) Для каждого свободного слота вызывает [method spawn_sword].[br]
##
## Использует:[br]
## - [member max_swords] — максимальное число активных мечей.[br]
## - [member attack_range] — дальность выбора целей.[br]
## - группу "enemy" — список врагов на сцене.[br]
## - группу "sword_attack" — уже существующие мечи.
func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var player_pos = player.global_position
	var current_swords = get_tree().get_nodes_in_group("sword_attack").size()
	
	var free_slots = max_swords - current_swords
	if free_slots <= 0:
		return

	var enemies: Array = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(
		func(enemy: Node2D) -> bool:
			return enemy.global_position.distance_squared_to(player_pos) < pow(attack_range, 2)
	)
	if enemies.is_empty():
		return

	enemies.sort_custom(
		func(a: Node2D, b: Node2D) -> bool:
			var a_distance = a.global_position.distance_squared_to(player_pos)
			var b_distance = b.global_position.distance_squared_to(player_pos)
			return a_distance < b_distance
	)

	var used_targets: Array[Node2D] = []
	for i in range(free_slots):
		if enemies.is_empty():
			break

		var chosen_enemy: Node2D = null
		for e in enemies:
			var enemy := e as Node2D
			if not used_targets.has(enemy):
				chosen_enemy = enemy
				break

		if chosen_enemy == null:
			chosen_enemy = enemies[0] as Node2D

		used_targets.append(chosen_enemy)
		spawn_sword(player, player_pos, chosen_enemy)
