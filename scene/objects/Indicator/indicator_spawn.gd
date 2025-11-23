extends Node2D

@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("default")


func _on_timer_timeout():
	queue_free()
