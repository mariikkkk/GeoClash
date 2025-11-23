extends CharacterBody2D

@onready var camera_2d = $"../Camera2D"
@onready var grace_period = $GracePeriod
@onready var progress_bar = $ProgressBar
@export var experience_manager: ExperienceManager
@onready var health_component = $HealthComponent
@onready var attack_contoller = $AttackManager/AttackContoller

var max_speed = 125
var acceleration = 0.16
var enemies_colliding = 0 #количество врагов, которые соприкасаются с персонажем 

func _ready():
	if health_component and experience_manager.has_signal("lvl_up"):
		experience_manager.lvl_up.connect(Callable(health_component, "on_level_up"))
	health_component.died.connect(on_died)
	health_component.health_changed.connect(on_health_changed)
	health_update()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): 
	var direction = movement_vector().normalized()
	var target_velocity = max_speed * direction
	velocity = velocity.lerp(target_velocity, acceleration)
	move_and_slide()

func movement_vector():
	var movement_x = Input.get_action_strength("move_right_up") - Input.get_action_strength("move_left_up")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)


func _on_player_hurt_box_area_entered(area):
	enemies_colliding += 1
	camera_2d.shake(0.08)   # 0.08 секунд лёгкой встряски
	check_if_damaged()


func _on_player_hurt_box_area_exited(area):
	enemies_colliding -= 1
	
func check_if_damaged():
	if enemies_colliding == 0 || !grace_period.is_stopped():
		return
	health_component.take_damage(1)
	grace_period.start()
	
func on_died():
	queue_free()
func health_update():
	progress_bar.value = health_component.get_health_value()
func on_health_changed():
	health_update()
