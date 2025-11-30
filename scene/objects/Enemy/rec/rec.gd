## Простой враг, который движется к игроку и умирает после получения урона.[br]
## При смерти отправляет [signal enemy_killed] и проигрывает эффекты.
class_name RecEnemy
extends CharacterBody2D

## Скорость движения.
var max_speed := 70

## Дистанция, на которой враг начинает преследовать игрока.
var max_distance := 1200

## Спрайт врага.
@onready var rec = $Rec

## Компонент здоровья.
@onready var health_component = $HealthComponent

## Частицы смерти.
@onready var death_particles: GPUParticles2D = $DeathParticles

## Хитбокс врага.
@onready var hit_box_shape: CollisionShape2D = $EnemyHitBox/HitBoxShape

## Хартбокс врага.
@onready var hurt_box_shape: CollisionShape2D = $HurtBoxComponent/HurtBoxShape

## Срабатывает при смерти врага.
signal enemy_killed


## Подключает сигналы здоровья.
func _ready() -> void:
	health_component.died.connect(on_died)
	health_component.damaged.connect(_on_damaged)


## Короткий эффект попадания. При получении урона мигает.
func flash_hit() -> void:
	var tween := create_tween()
	tween.tween_property(rec, "modulate", Color(1, 1, 1, 1), 0.05)
	tween.tween_property(rec, "modulate", Color(0, 0, 0, 1), 0.1)


## Реакция на урон. [param _amount] передает величину урона.
func _on_damaged(_amount: int) -> void:
	flash_hit()
	GameSoundManager.play_enemy_hitting()


## Движение врага к игроку.
func _process(_delta: float) -> void:
	var direction := get_direction_to_player()
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	velocity = max_speed * direction

	if global_position.distance_squared_to(player.global_position) < pow(max_distance, 2):
		move_and_slide()


## Направление к игроку. Если игрок не найден — ZERO.
func get_direction_to_player() -> Vector2:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO


## Обработка смерти врага. Отключает логику, запускает эффекты и удаляет объект.
func on_died() -> void:
	enemy_killed.emit()
	set_physics_process(false)
	set_process(false)

	hit_box_shape.visible = false
	hurt_box_shape.visible = false

	var tween := create_tween()
	tween.tween_property(rec, "modulate:a", 0.0, 0.4)

	GameSoundManager.play_enemy_dead()

	if death_particles:
		death_particles.emitting = true
		var death_time := death_particles.lifetime
		await get_tree().create_timer(death_time).timeout

	queue_free()
