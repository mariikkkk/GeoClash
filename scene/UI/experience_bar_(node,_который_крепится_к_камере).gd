extends CanvasLayer

@onready var label = $Label
@export var experience_manager: ExperienceManager
@onready var progress_bar = $MarginContainer/ProgressBar
var tween: Tween

func _ready():
	tween = create_tween()
	progress_bar.value = 0
	experience_manager.exp_update.connect(on_exp_updated)
	
func on_exp_updated(current_exp:float, target_exp:float):
	tween.kill()
	tween = create_tween()
	tween.tween_property(progress_bar, "value", current_exp / target_exp, 0.2)
	label.text = "Level: %d" % experience_manager.current_level
