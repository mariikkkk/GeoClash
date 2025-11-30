## Основная сцена уровня.[br]
## Отвечает за:[br]
## - показ экрана окончания игры при смерти игрока;  [br]
## - открытие меню паузы по нажатию Esc (ui_cancel).
extends Node
class_name Level

## Игрок в сцене уровня.
@onready var player = $player

## Сцена экрана окончания игры.
@export var end_screen_scene: PackedScene

## Сцена меню паузы.
@export var pause_screen_scene: PackedScene


## Подписывает уровень на событие смерти игрока.
func _ready():
	player.health_component.died.connect(on_died)


## Показывает экран окончания игры.
func on_died():
	var end_screen_instance = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)


## Отслеживает кнопку паузы и открывает меню.
##
## [param _delta] — время кадра (не используется напрямую).
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var pause_screen_instance = pause_screen_scene.instantiate() as PauseMenu
		add_child(pause_screen_instance)
