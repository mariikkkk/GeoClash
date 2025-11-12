extends Node

@export var end_screen_scene: PackedScene
@export var pause_screen_scene: PackedScene
@onready var player = $player

func _ready():
	player.health_component.died.connect(on_died)
	
func on_died():
	var end_screen_instance = end_screen_scene.instantiate() as EndScreen 
	add_child(end_screen_instance)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var pause_screen_instance = pause_screen_scene.instantiate() as PauseMenu
		add_child(pause_screen_instance)
