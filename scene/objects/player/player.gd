## Игрок. Движение по вводу, получение урона, взаимодействие с опытом и камерой.[br]
## Обрабатывает здоровье, подбор предметов, неуязвимость и реакции на врагов.
class_name Player
extends CharacterBody2D

## Камера игрока.
@onready var camera_2d = $"../Camera2D"

## Таймер неуязвимости после получения урона.
@onready var grace_period = $GracePeriod

## Полоска здоровья.
@onready var progress_bar = $ProgressBar

## Менеджер опыта.
@export var experience_manager: ExperienceManager

## Компонент здоровья.
@onready var health_component = $HealthComponent

## Контроллер атак игрока.
@onready var attack_contoller = $AttackManager/AttackContoller

## Коллизия для подбора.
@onready var pick_up_collision: CollisionShape2D = $PickUpArea/PickUpCollision

## Спрайт игрока.
@onready var circ: Sprite2D = $Circ

## Максимальная скорость.
var max_speed = 125

## Ускорение движения.
var acceleration = 0.16

## Количество врагов, касающихся игрока.
var enemies_colliding = 0


## Подключает сигналы здоровья и уровня.
func _ready():
	if health_component and experience_manager.has_signal("lvl_up"):
		experience_manager.lvl_up.connect(Callable(health_component, "on_level_up"))
	health_component.died.connect(on_died)
	health_component.health_changed.connect(on_health_changed)
	health_update()


## Движение игрока с плавным ускорением.
##
## [param _delta] — время кадра (не используется напрямую).
func _process(_delta): 
	var direction = movement_vector().normalized()
	var target_velocity = max_speed * direction
	velocity = velocity.lerp(target_velocity, acceleration)
	move_and_slide()


## Возвращает вектор движения от ввода игрока.
##
## Использует: [br]
## - действия "move_right_up", "move_left_up"[br]
## - действия "move_up", "move_down"[br]
func movement_vector():
	var movement_x = Input.get_action_strength("move_right_up") - Input.get_action_strength("move_left_up")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)


## Игрок касается вражеской зоны урона.
##
## [param _area] — зона, вошедшая в хитбокс игрока.
func _on_player_hurt_box_area_entered(_area):
	enemies_colliding += 1
	camera_2d.shake(0.08)
	check_if_damaged()


## Враг выходит из зоны урона.
##
## [param _area] — зона, покинувшая хитбокс игрока.
func _on_player_hurt_box_area_exited(_area):
	enemies_colliding -= 1


## Проверяет, нужно ли нанести урон игроку.[br]
## Условия:[br]
## - есть активные столкновения;[br]
## - таймер неуязвимости остановлен.
func check_if_damaged():
	if enemies_colliding == 0 || !grace_period.is_stopped():
		return
	health_component.take_damage(1)
	grace_period.start()

## Удаляет игрока при смерти.
func on_died():
	queue_free()

## Обновляет полоску здоровья.
func health_update():
	progress_bar.value = health_component.get_health_value()

## Вызывается при изменении здоровья.
func on_health_changed():
	health_update()

## Увеличивает радиус подбора.
##
## [param mult] — множитель увеличения радиуса.
func increase_pickup_radius(mult):
	pick_up_collision.shape.radius *= mult
