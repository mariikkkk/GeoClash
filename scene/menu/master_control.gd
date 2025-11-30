## Контроллер громкости мастер-канала.[br]
## Синхронизирует положение слайдера с глобальными настройками
## и обновляет громкость при изменении значения.
extends HSlider
class_name MasterControl

## Инициализирует позицию слайдера из GlobalSettings.
func _ready():
	value = GlobalSettings.volume_master * max_value


## Обновляет громкость мастер-канала.
##
## [param v] — новое значение слайдера.
func _on_value_changed(v: float) -> void:
	GlobalSettings.volume_master = v / max_value
	GlobalSettings.apply_audio_settings()


## Проигрывает звук наведения.
func _on_mouse_entered():
	UISoundManager.play_hover()
