## Контроллер громкости музыки.[br]
## Синхронизирует положение слайдера с глобальными настройками
## и обновляет громкость музыкального канала.
extends HSlider
class_name MusicControl

## Инициализирует позицию слайдера из GlobalSettings.
func _ready():
	value = GlobalSettings.volume_music * max_value


## Обновляет громкость музыкального канала.
##
## [param v] — новое значение слайдера.
func _on_value_changed(v: float) -> void:
	GlobalSettings.volume_music = v / max_value
	GlobalSettings.apply_audio_settings()


## Проигрывает звук наведения.
func _on_mouse_entered():
	UISoundManager.play_hover()
