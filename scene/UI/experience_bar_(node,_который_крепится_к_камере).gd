extends CanvasLayer

@onready var label = $Label
@export var experience_manager: ExperienceManager
@onready var progress_bar = $MarginContainer/ProgressBar
var tween: Tween
<<<<<<< HEAD
var player: Node2D
=======
<<<<<<< HEAD
var player: Node2D
=======
>>>>>>> 5b609378e69c6b6751622eae0fa1f93e53bec63b
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d

func _ready():
	tween = create_tween()
	progress_bar.value = 0
	experience_manager.exp_update.connect(on_exp_updated)
	
func on_exp_updated(current_exp:float, target_exp:float):
	tween.kill()
	tween = create_tween()
	tween.tween_property(progress_bar, "value", current_exp / target_exp, 0.2)
	label.text = "Level: %d" % experience_manager.current_level
