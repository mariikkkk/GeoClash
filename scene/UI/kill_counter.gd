## UI-счётчик убитых врагов.[br]
## Отображает общее количество убийств в текущей сессии.
extends CanvasLayer
class_name KillCounterUI

## Текстовая метка с числом убийств.
@onready var kill_label: Label = $HBoxContainer/KillLabel

## Текущее количество убийств.
var kill_count: int = 0


## Увеличивает счётчик после сигнала enemy_killed и обновляет UI.
func on_enemy_killed():
	kill_count += 1
	update_kill_ui()


## Обновляет отображаемое значение на экране.
func update_kill_ui():
	kill_label.text = str(kill_count)
