extends Node

@export var attack_abillity: PackedScene
@export var attack_range = 100
@export var sword_damage = 5

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var player_pos = player.global_position
	if player == null:
		return		
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	enemies = enemies.filter(func(enemy:Node2D): return enemy.global_position.distance_squared_to(player_pos) < pow(attack_range, 2))
	if enemies.size() == 0:
		return
	else:
		enemies.sort_custom(func(a:Node2D, b:Node2D): 
			var a_distance = a.global_position.distance_squared_to(player_pos) 
			var b_distance = b.global_position.distance_squared_to(player_pos)
			return a_distance < b_distance
			)
	var enemy_pos = enemies[0].global_position
	var attack_instance = attack_abillity.instantiate() as SwordAttackAbility
	player.get_parent().add_child(attack_instance)
	attack_instance.hit_box_component.damage = sword_damage
	attack_instance.global_position = (enemy_pos + player_pos) / 2
	attack_instance.look_at(enemy_pos)
	
