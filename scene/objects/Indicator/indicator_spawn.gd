## Индикатор появления врага.[br]
## Проигрывает анимацию появления и автоматически удаляется по таймеру.
extends Node2D
class_name SpawnIndicator

## Анимированный спрайт индикатора.
@onready var animation = $AnimatedSprite2D


## Запускает анимацию появления.
func _ready():
	animation.play("default")


## Удаляет индикатор после срабатывания таймера.
func _on_timer_timeout():
	queue_free()
