## Контроллер громкости звуковых эффектов.[br]
## Синхронизирует положение слайдера с GlobalSettings
## и обновляет громкость канала SFX.
extends HSlider
class_name SFXControl

## Инициализирует позицию слайдера из GlobalSettings.
func _ready():
	value = GlobalSettings.volume_sfx * max_value


## Обновляет громкость канала SFX.
##
## [param v] — новое значение слайдера.
func _on_value_changed(v: float) -> void:
	GlobalSettings.volume_sfx = v / max_value
	GlobalSettings.apply_audio_settings()


## Проигрывает звук наведения.
func _on_mouse_entered():
	UISoundManager.play_hover()
