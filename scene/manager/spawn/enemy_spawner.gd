## Спавнер врагов.[br]
## Периодически создаёт врагов за пределами экрана, показывая индикатор появления,
## и подключает их сигналы к счётчику убийств.
extends Node
class_name EnemySpawner

## Сцена квадратного врага.
@export var rec_scene: PackedScene

## Сцена врага треугольника.
@export var triangle_scene: PackedScene

## Индикатор появления врага.
@export var spawn_indicator: PackedScene

## Задержка между индикатором и фактическим появлением врага.
@export var spawn_delay: float = 2.5

## Менеджер времени арены.
@export var arena_time_manager: Node

## Разрешение спавна треугольных врагов.
@export var triangle_enabled: bool = false

## Вес квадратного врага в пуле.
@export var rec_weight: int = 4

## Вес треугольного врага в пуле.
@export var triangle_weight: int = 1


## Возвращает позицию для спавна врага в случайном направлении вокруг игрока.[br]
##
## Логика:[br]
## - выбирает случайное направление из четырёх базовых;[br]
## - добавляет случайный поворот;[br]
## - проверяет, что между врагом и игроком нет препятствий (raycast);[br]
## - проверяет, что точка не пересекается с объектами (point query).
func get_spawn_pos():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var directions = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP].map(
		func(d): return d.rotated(randf_range(0, PI / 2))
	)
	directions.shuffle()

	for dir in directions:
		var distance = randi_range(400, 600)
		var spawn_pos = player.global_position + dir * distance

		var ray_params = PhysicsRayQueryParameters2D.create(
			spawn_pos,
			player.global_position
		)
		var ray_hit = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_params)
		if not ray_hit.is_empty():
			continue

		var point_params = PhysicsPointQueryParameters2D.new()
		point_params.position = spawn_pos
		point_params.collide_with_areas = true
		point_params.collide_with_bodies = true

		var point_hit = get_tree().root.world_2d.direct_space_state.intersect_point(point_params)
		if point_hit.is_empty():
			return spawn_pos

	return player.global_position


## Запускает процесс спавна врага после таймера.[br]
##
## Логика:[br]
## - определяет позицию спавна;[br]
## - создаёт индикатор появления;[br]
## - ждёт задержку;[br]
## - выбирает тип врага через [method _pick_enemy_scene];[br]
## - создаёт врага и подключает его к KillCounterUI.
func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var pos = get_spawn_pos()

	if spawn_indicator:
		var indicator = spawn_indicator.instantiate() as Node2D
		get_parent().add_child(indicator)
		indicator.global_position = pos

	await get_tree().create_timer(spawn_delay, false).timeout

	var scene = _pick_enemy_scene()
	if scene == null:
		return

	var enemy = scene.instantiate() as Node2D
	get_parent().add_child(enemy)
	enemy.global_position = pos

	var kill_counter = get_tree().get_first_node_in_group("kill_counter_ui") as KillCounterUI
	if kill_counter:
		enemy.enemy_killed.connect(kill_counter.on_enemy_killed)


## Выбирает сцену врага на основе веса и условий.[br]
##
## Логика:[br]
## - треугольный враг включается после 20 сек времени;[br]
## - создаётся пул, куда сцены добавляются по весам;[br]
## - возвращается случайный элемент пула.
func _pick_enemy_scene():
	var pool: Array[PackedScene] = []

	if arena_time_manager.get_time_elapsed() >= 20 and triangle_enabled == false:
		triangle_enabled = true

	if rec_scene and rec_weight > 0:
		for i in range(rec_weight):
			pool.append(rec_scene)

	if triangle_enabled and triangle_scene and triangle_weight > 0:
		for i in range(triangle_weight):
			pool.append(triangle_scene)

	if pool.is_empty():
		return rec_scene

	return pool.pick_random()
