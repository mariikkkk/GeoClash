extends Node

@export var attack_abillity: PackedScene
@export var attack_range: float = 200.0
@export var sword_damage: int = 5
@export var max_swords: int = 3
@export var sword_scale: float = 1.5
@export var attack_cooldown: float = 1.0

@onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.wait_time = attack_cooldown
	_timer.start()
func spawn_sword(player: Node2D, player_pos: Vector2, enemy: Node2D):
	var enemy_pos = enemy.global_position
	var attack_instance = attack_abillity.instantiate() as SwordAttackAbility
	player.get_parent().add_child(attack_instance)

	attack_instance.hit_box_component.damage = sword_damage
	attack_instance.scale = Vector2.ONE * sword_scale

	var dir = (enemy_pos - player_pos).normalized()
	var offset: float = 50.0
	attack_instance.global_position = enemy_pos - dir * offset
	attack_instance.look_at(enemy_pos)

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var player_pos = player.global_position
	var current_swords = get_tree().get_nodes_in_group("sword_attack").size()
	var free_slots = max_swords - current_swords
	if free_slots <= 0:
		return
	var enemies: Array = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(
		func(enemy: Node2D) -> bool:
			return enemy.global_position.distance_squared_to(player_pos) < pow(attack_range, 2)
	)
	if enemies.is_empty():
		return
	enemies.sort_custom(
		func(a: Node2D, b: Node2D) -> bool:
			var a_distance = a.global_position.distance_squared_to(player_pos)
			var b_distance = b.global_position.distance_squared_to(player_pos)
			return a_distance < b_distance
	)
	var used_targets: Array[Node2D] = []
	for i in range(free_slots):
		if enemies.is_empty():
			break
		var chosen_enemy: Node2D = null
		for e in enemies:
			var enemy := e as Node2D
			if not used_targets.has(enemy):
				chosen_enemy = enemy
				break
		if chosen_enemy == null:
			chosen_enemy = enemies[0] as Node2D
		used_targets.append(chosen_enemy)
		spawn_sword(player, player_pos, chosen_enemy)
