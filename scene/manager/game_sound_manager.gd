## Менеджер игровых звуков.[br]
## Хранит аудиоплееры и предоставляет методы для воспроизведения звуков.
extends Node
class_name GameSoundManagerClass

## Звук удара по врагу.
@onready var enemy_hitting: AudioStreamPlayer2D = $EnemyHitting

## Звук повышения уровня.
@onready var lvl_up: AudioStreamPlayer2D = $LvlUp

## Звук смерти врага.
@onready var enemy_dead: AudioStreamPlayer2D = $EnemyDead

## Звук поднятия опыта.
@onready var exp_raise: AudioStreamPlayer2D = $ExpRaise

## Звук восстановления здоровья.
@onready var hp_recovery: AudioStreamPlayer2D = $HpRecovery


## Разрешает воспроизведение звуков даже при паузе игры.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


## Проигрывает звук повышения уровня.
func play_lvlup():
	lvl_up.play()


## Проигрывает звук удара по врагу.
func play_enemy_hitting():
	enemy_hitting.play()


## Проигрывает звук смерти врага.
func play_enemy_dead():
	enemy_dead.play()


## Проигрывает звук поднятия опыта.
func play_exp_raise():
	exp_raise.play()


## Проигрывает звук восстановления HP.
func play_hp_recovery():
	hp_recovery.play()
