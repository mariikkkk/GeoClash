## Компонент здоровья.[br]
## Управляет текущим здоровьем, обработкой урона и сигналами смерти/изменений.
extends Node
class_name HealthComponent

## Срабатывает при смерти (здоровье достигло 0).
signal died

## Срабатывает при изменении текущего здоровья.
signal health_changed

## Срабатывает при получении урона.
## [param amount] — величина нанесённого урона.
signal damaged(amount: int)

## Максимальное здоровье.
@export var max_health: float

## Текущее здоровье.
var current_health: float


## Инициализация текущего здоровья.
func _ready():
	current_health = max_health


## Наносит компоненту урон и вызывает сигналы.
##
## [param damage] — величина урона.
func take_damage(damage):
	current_health = max(current_health - damage, 0)
	health_changed.emit()
	damaged.emit(damage)
	Callable(check_death).call_deferred()


## Возвращает процент здоровья (0.0–1.0).
func get_health_value():
	return current_health / max_health


## Проверяет смерть и вызывает соответствующий сигнал.
func check_death():
	if current_health == 0:
		died.emit()


## Обработчик повышения уровня.
func on_level_up(_current_level):
	#current_health = max_health
	health_changed.emit()
