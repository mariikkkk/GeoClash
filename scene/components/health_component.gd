extends Node
class_name HealthComponent

signal died
signal health_changed
signal damaged(amount: int)
@export var max_health : float = 10
var current_health: float
@export var exp_manager: ExperienceManager

func _ready():
	current_health = max_health

	
func take_damage(damage):
	current_health = max(current_health - damage, 0)
#	print("[DMG]", owner.name, " -", damage)
	health_changed.emit()
	damaged.emit(damage)
	Callable(check_death).call_deferred() #чтобы не было ошибки

	
func get_health_value():
	return current_health / max_health
	
func check_death():
	if current_health == 0:
		died.emit()

func on_level_up(_current_level):
	current_health = max_health # Восстанавливаем здоровье
	health_changed.emit() # Уведомляем об изменении здоровья
	
