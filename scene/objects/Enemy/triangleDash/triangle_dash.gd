extends CharacterBody2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var health_component = $HealthComponent
@onready var triangle_dash = $TriangleDash

@export var max_speed := 80.0 # Скорость преследования
@export var dash_speed := 380.0 # Скорость рывка
@export var dash_trigger_dist := 120.0 # С какого расстояния начинатся подготовка к рвыку
@export var windup := 0.25 # Длительность подготовки
@export var dash_time := 0.3 # Длительность рывка
@export var cooldown := 0.6 # Откат после рывка
@export var rotate_speed := 12.0 # Скорость поворота в рад сек

func _ready():
	health_component.died.connect(on_died)
	health_component.damaged.connect(_on_damaged)
	
func on_died():
	queue_free()
	
func flash_hit():
	var tween := create_tween()
	# Сначала делаем яркую вспышку
	tween.tween_property(triangle_dash, "modulate", Color(1, 1, 1, 1), 0.05)
	tween.tween_property(triangle_dash, "modulate", Color(0, 0, 0, 1), 0.1)
	
func _on_damaged(amount: int) -> void:
	flash_hit()
	audio_stream_player_2d.play()
enum State { CHASE, WINDUP, DASH, COOLDOWN }
var state: State = State.CHASE # Текущее состояние врага

var t := 0.0 # таймер текущего состояния
var dash_dir := Vector2.RIGHT # направление рывка
func _physics_process(delta: float):
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# Поврот к игроку
	var face_dir: Vector2
	if state == State.DASH: # Если враг в состоянии дэша, то берем зафиксированное направление 
		face_dir = dash_dir
	else:
		face_dir = (player.global_position - global_position).normalized() # Иначе берем вектор игрока
	var to_player := player.global_position - global_position
	if to_player.length_squared() > 0.0001:
		face_dir = to_player.normalized()
	var target_angle := face_dir.angle() # возвращает угол в радианах относитлеьно оси x,
	rotation = lerp_angle(rotation, target_angle, clamp(rotate_speed * delta, 0.0, 1.0)) # rotation - текущий угол узла, lerp_angle - интерполирует угол по кратчайшей дуге между 1 и 2 и берет долю 3, rotate_speed * delta - насколько быстро догоняем цель за один кадр, clamp - ограничение в диапазоне от 0 до 1
	
	match state:
		State.CHASE: # Преследование
			var dir := (player.global_position - global_position).normalized()
			velocity = dir * max_speed
			move_and_slide() # Направляемся к игроку с обычной скоростью
			
			if global_position.distance_to(player.global_position) < dash_trigger_dist: # Если подошли ближе порога, переходим в состояние рывка
				state = State.WINDUP
				t = 0.0
				
		State.WINDUP: # Замах
			velocity = Vector2.ZERO
			t += delta
			if t >= windup: # Как только проходит время замаха
				dash_dir = (player.global_position - global_position).normalized()
				state = State.DASH
				t = 0.0
		State.DASH: 
			velocity = dash_dir * dash_speed
			move_and_slide()
			t += delta
			if t >= dash_time:
				velocity = Vector2.ZERO
				state = State.COOLDOWN
				t = 0.0
		State.COOLDOWN:
			velocity = Vector2.ZERO
			t += delta
			if t >= cooldown:
				state = State.CHASE
				t = 0.0
		
