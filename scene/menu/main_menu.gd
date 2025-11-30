## Главное меню игры.[br]
## Управляет кнопками запуска игры, настройки, выхода и переключением UI-блоков.
extends Control
class_name MainMenu

## Кнопка "Start".
@onready var start = $MainButtons/Start

## Кнопка "Settings".
@onready var settings = $MainButtons/Settings

## Кнопка "Exit".
@onready var exit = $MainButtons/Exit

## Контейнер меню настроек.
@onready var options = $Options

## Контейнер главных кнопок.
@onready var main_buttons = $MainButtons

## Текст/логотип игры.
@onready var game_name = $GameName

## Украшения/фигуры главного меню.
@onready var figures = $Figures

## Контроллер выбора FPS.
@onready var fps_control: OptionButton = $Options/Display/FpsControlBox/FpsControl


## Инициализация главного меню и подключение сигналов.
func _ready():
	start.pressed.connect(_on_start_pressed)
	settings.pressed.connect(_on_settings_pressed)
	exit.pressed.connect(_on_exit_pressed)

	options.visible = false
	figures.visible = true
	main_buttons.visible = true
	game_name.visible = true

	# Обновляем UI контроллера FPS вручную.
	fps_control._ready()

	GlobalSettings.apply_display_settings()
	GlobalSettings.apply_audio_settings()


## Запуск игры.
func _on_start_pressed():
	UISoundManager.play_click()
	get_tree().change_scene_to_file("res://scene/Level/level.tscn")


## Наведение на кнопку старта.
func _on_start_mouse_entered():
	UISoundManager.play_hover()


## Открыть меню настроек.
func _on_settings_pressed():
	print("Открывается меню настроек...")
	UISoundManager.play_click()
	options.visible = true
	figures.visible = false
	main_buttons.visible = false
	game_name.visible = false


## Наведение на кнопку настроек.
func _on_settings_mouse_entered():
	UISoundManager.play_hover()


## Выйти из игры.
func _on_exit_pressed():
	UISoundManager.play_click()
	get_tree().quit()


## Наведение на кнопку выхода.
func _on_exit_mouse_entered():
	UISoundManager.play_hover()


## Вернуться из меню настроек.
func _on_back_pressed():
	UISoundManager.play_click()
	options.visible = false
	figures.visible = true
	main_buttons.visible = true
	game_name.visible = true


## Наведение на кнопку "назад".
func _on_back_mouse_entered():
	UISoundManager.play_hover()
