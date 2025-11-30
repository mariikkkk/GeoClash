## Менеджер звуков интерфейса.[br]
## Проигрывает звуки клика, наведения и переключения UI-элементов.
extends Node
class_name UISoundManagerClass



## Звук клика кнопки.
@onready var click_button = $ClickButton

## Звук наведения курсора.
@onready var hover_button = $HoverButton

## Звук переключения значений (тогглы, чекбоксы).
@onready var switch_button = $SwitchButton


## Позволяет воспроизводить звуки даже во время паузы.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


## Проигрывает звук наведения.
func play_hover():
	hover_button.play()


## Проигрывает звук клика.
func play_click():
	click_button.play()


## Проигрывает звук переключения.
func play_switch():
	switch_button.play()
