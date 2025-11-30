## Глобальные настройки игры.[br]
## Хранит параметры звука, FPS и режима окна, а также применяет их.
#class_name GlobalSettings
extends Node

## Максимальный FPS.
var max_fps = 60

## Громкость мастер-канала (0.0–1.0).
var volume_master = 1.0

## Громкость звуковых эффектов (0.0–1.0).
var volume_sfx = 1.0

## Громкость музыки (0.0–1.0).
var volume_music = 1.0

## Полноэкранный режим.
var fullscreen: bool = true


## Применяет настройки отображения (полноэкранный/оконный режим).
func apply_display_settings() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


## Применяет настройки громкости.
func apply_audio_settings() -> void:
	_set_bus("Master", volume_master)
	_set_bus("SFX", volume_sfx)
	_set_bus("Music", volume_music)


## Устанавливает громкость указанного аудио-баса.
##
## [param bus] — имя аудио-канала.[br]
## [param v] — громкость (0.0–1.0).
func _set_bus(bus: String, v: float) -> void:
	v = clamp(v, 0.0, 1.0)

	var db = linear_to_db(v if v > 0.001 else 0.001)
	var idx = AudioServer.get_bus_index(bus)
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, db)
