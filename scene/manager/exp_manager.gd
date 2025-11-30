## Менеджер опыта и уровней.[br]
## Хранит текущий опыт, целевой опыт, текущий уровень
## и обрабатывает получение опыта и повышение уровня.
extends Node
class_name ExperienceManager



## Срабатывает при изменении прогресса опыта.
## [param current_experience] — обновлённое значение опыта.[br]
## [param target_experience] — требуемый опыт для уровня.
signal exp_update(current_experience: float, target_experience: float)

## Срабатывает при повышении уровня.
## [param current_level] — новый уровень игрока.
signal lvl_up(current_level)

## Текущее количество опыта.
@export var current_exp = 0

## Требуемое количество опыта для текущего уровня.
@export var target_exp = 5

## Увеличение требуемого опыта после каждого уровня.
@export var target_after_lvlup = 5

## Текущий уровень игрока.
@export var current_level = 1


## Подключает менеджер к глобальному сигналу сбора опыта.
func _ready():
	Global.exp_bottle_collected.connect(on_exp_bottle_collected)


## Обрабатывает получение опыта и повышение уровня.
##
## [param new_exp] — количество полученного опыта.
func on_exp_bottle_collected(new_exp):
	current_exp = min(current_exp + new_exp, target_exp)
	GameSoundManager.play_exp_raise()
	exp_update.emit(current_exp, target_exp)

	if current_exp == target_exp:
		GameSoundManager.play_lvlup()
		current_level += 1
		current_exp = 0
		target_exp += target_after_lvlup

		exp_update.emit(current_exp, target_exp)
		lvl_up.emit(current_level)
