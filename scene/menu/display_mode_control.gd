## Контроллер переключения режима отображения.[br]
## Управляет переходом между полноэкранным и оконным режимом и обновляет текстовое поле UI.
extends CheckButton
class_name DisplayModeController


## Текстовое поле с отображением режима (FULLSCREEN / WINDOWED).
@export var display_mode_text: Label


## Инициализация состояния кнопки и UI.
func _ready() -> void:
	button_pressed = GlobalSettings.fullscreen
	_update_text(GlobalSettings.fullscreen)


## Переключает режим окна.
##
## [param toggled_on] — новое состояние fullscreen.
func _on_toggled(toggled_on: bool) -> void:
	GlobalSettings.fullscreen = toggled_on
	GlobalSettings.apply_display_settings()
	_update_text(toggled_on)


## Обновляет текст режима.
##
## [param state] — текущее состояние fullscreen.
func _update_text(state: bool) -> void:
	display_mode_text.text = "FULLSCREEN" if state else "WINDOWED"


## Звук нажатия.
func _on_pressed() -> void:
	UISoundManager.play_click()


## Звук наведения.
func _on_mouse_entered() -> void:
	UISoundManager.play_hover()
