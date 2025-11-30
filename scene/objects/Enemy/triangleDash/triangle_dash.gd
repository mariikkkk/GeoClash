extends CharacterBody2D
class_name TriangleDashEnemy

## Враг, который преследует игрока и периодически делает рывок (dash).[br]
## Имеет 4 состояния: CHASE → WINDUP → DASH → COOLDOWN.
## Реагирует на урон, проигрывает эффекты и удаляется при смерти.

## Компонент здоровья врага.
@onready var health_component = $HealthComponent

## Спрайт/узел, отвечающий за визуальную часть треугольного врага.
@onready var triangle_dash = $TriangleDash

## Хартбокс врага — получает урон от атак игрока.
@onready var hurt_box_shape: CollisionShape2D = $HurtBoxComponent/HurtBoxShape

## Хитбокс врага — наносит урон игроку.
@onready var hit_box_shape: CollisionShape2D = $EnemyHitBox/HitBoxShape

## Частицы смерти, проигрываются после уничтожения врага.
@onready var death_particles: GPUParticles2D = $DeathParticles

## Скорость обычного преследования.
@export var max_speed := 80.0

## Скорость рывка.
@export var dash_speed := 380.0

## Дистанция, с которой начинается подготовка к рывку.
@export var dash_trigger_dist := 120.0

## Время подготовки (замаха) перед рывком.
@export var windup := 0.25

## Длительность самого рывка.
@export var dash_time := 0.3

## Время восстановления после рывка.
@export var cooldown := 0.6

## Скорость поворота к игроку (рад/сек).
@export var rotate_speed := 12.0

## Сигнал смерти врага.
signal enemy_killed


## Подключает сигналы здоровья.
func _ready():
	health_component.died.connect(on_died)
	health_component.damaged.connect(_on_damaged)


## Обработка смерти врага: отключение логики, эффекты, удаление.
func on_died():
	enemy_killed.emit()
	set_physics_process(false)
	set_process(false)
	hit_box_shape.visible = false
	hurt_box_shape.visible = false

	var tween := create_tween()
	tween.tween_property(triangle_dash, "modulate:a", 0.0, 0.4)

	GameSoundManager.play_enemy_dead()

	if death_particles:
		death_particles.emitting = true
		var death_time := death_particles.lifetime
		await get_tree().create_timer(death_time).timeout

	queue_free()


## Визуальная вспышка при получении урона.
func flash_hit():
	var tween := create_tween()
	tween.tween_property(triangle_dash, "modulate", Color(1, 1, 1, 1), 0.05)
	tween.tween_property(triangle_dash, "modulate", Color(0, 0, 0, 1), 0.1)


## Реакция на получение урона.
##
## [param amount] — величина урона.
func _on_damaged(amount: int) -> void:
	flash_hit()
	GameSoundManager.play_enemy_hitting()


## Состояния врага.
enum State { 
	CHASE, ## Преследование игрока
	WINDUP, ## Заряд атаки
	DASH,  ## Быстрый рывок в направлении игрока
	COOLDOWN ## Пауза после атаки и перед началом преследования
	}
	

## Текущее состояние.
var state: State = State.CHASE

## Таймер внутри состояния.
var t := 0.0

## Направление рывка.
var dash_dir := Vector2.RIGHT


## Основная логика поведения врага, включая поворот, движение и смену состояний.
##
## Пошагово:[br]
## - CHASE: преследует игрока; при приближении -> WINDUP[br]
## - WINDUP: стоит на месте, «заряжает» рывок[br]
## - DASH: быстрый рывок по фиксированному направлению[br]
## - COOLDOWN: пауза перед возвратом к CHASE
func _physics_process(delta: float):
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	# Поворот к игроку
	var face_dir: Vector2
	if state == State.DASH:
		face_dir = dash_dir
	else:
		face_dir = (player.global_position - global_position).normalized()

	var to_player := player.global_position - global_position
	if to_player.length_squared() > 0.0001:
		face_dir = to_player.normalized()

	var target_angle := face_dir.angle()
	rotation = lerp_angle(rotation, target_angle, clamp(rotate_speed * delta, 0.0, 1.0))

	match state:

		State.CHASE:
			var dir := (player.global_position - global_position).normalized()
			velocity = dir * max_speed
			move_and_slide()

			if global_position.distance_to(player.global_position) < dash_trigger_dist:
				state = State.WINDUP
				t = 0.0

		State.WINDUP:
			velocity = Vector2.ZERO
			t += delta
			if t >= windup:
				dash_dir = (player.global_position - global_position).normalized()
				state = State.DASH
				t = 0.0

		State.DASH:
			velocity = dash_dir * dash_speed
			move_and_slide()
			t += delta
			if t >= dash_time:
				velocity = Vector2.ZERO
				state = State.COOLDOWN
				t = 0.0

		State.COOLDOWN:
			velocity = Vector2.ZERO
			t += delta
			if t >= cooldown:
				state = State.CHASE
				t = 0.0
