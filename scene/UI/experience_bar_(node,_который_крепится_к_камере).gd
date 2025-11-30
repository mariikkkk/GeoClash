## Полоса опыта игрока.[br]
## Показывает текущий уровень и анимированно обновляет прогресс опыта.
extends CanvasLayer
class_name ExperienceBar

## Текст с отображением уровня.
@onready var label = $Label

## Менеджер опыта.
@export var experience_manager: ExperienceManager

## Прогресс-бар опыта.
@onready var progress_bar = $MarginContainer/ProgressBar

## Твин для плавного обновления значения.
var tween: Tween


## Инициализация полосы опыта и подписка на сигнал обновления.
func _ready():
	tween = create_tween()
	progress_bar.value = 0
	experience_manager.exp_update.connect(on_exp_updated)


## Обновляет прогресс опыта и текст уровня.
##
## [param current_exp] — текущее количество опыта.[br]
## [param target_exp] — требуемое количество опыта до следующего уровня.
func on_exp_updated(current_exp: float, target_exp: float):
	tween.kill()
	tween = create_tween()
	tween.tween_property(progress_bar, "value", current_exp / target_exp, 0.2)
	label.text = "Level: %d" % experience_manager.current_level
