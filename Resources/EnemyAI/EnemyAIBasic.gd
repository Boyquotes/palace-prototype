extends Resource

# basic AI:
# 1. check if a unit is in attack range
# 2. If is, attack. Else, move towards closest unit
# enemy should have ATTACK_RANGE
func pick_action(enemy):
	var decision = EnemyDecision.new()
	
	var attack_range = []
	for v in enemy.ATTACK_RANGE:
		if Global.grid.is_within_bounds(enemy.grid_pos + v):
			attack_range.append(enemy.grid_pos + v)
			
	decision.action = Constants.ENEMY_ACTIONS.MOVE
	for t in attack_range:
		if Global.units[t]:
			decision.action = Constants.ENEMY_ACTIONS.ATTACK
			
	return decision
