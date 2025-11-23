extends Node
class_name HealthComponent

signal died
signal health_changed
signal damaged(amount: int)
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
@export var max_health : float
var current_health: float


func _ready():
	current_health = max_health

	
func take_damage(damage):
	current_health = max(current_health - damage, 0)
#	print("[DMG]", owner.name, " -", damage)
	health_changed.emit()
	damaged.emit(damage)
	Callable(check_death).call_deferred()
<<<<<<< HEAD
=======
=======
@export var health_per_level: float = 5.0
@export var max_health : float = 10
@export var current_health: float
@export var exp_manager: ExperienceManager

func _ready():
	current_health = max_health
	
func take_damage(damage):
	current_health = max(current_health - damage, 0)
	print("[DMG]", owner.name, " -", damage)
	health_changed.emit()
	damaged.emit(damage)
	Callable(check_death).call_deferred() #чтобы не было ошибки
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d

	
func get_health_value():
	return current_health / max_health
	
func check_death():
	if current_health == 0:
		died.emit()

func on_level_up(_current_level):
<<<<<<< HEAD
	current_health = max_health
	health_changed.emit() 
=======
<<<<<<< HEAD
	current_health = max_health
	health_changed.emit() 
=======
	max_health += 1 # Увеличиваем максимальное здоровье на 1
	current_health = max_health # Восстанавливаем здоровье
	health_changed.emit() # Уведомляем об изменении здоровья
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
	
