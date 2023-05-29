extends AnimatedSprite2D

signal continue_action

enum STATES {IDLE, WINDUP}

# move: move, and wind up attack if unit is in attack range
# attack: attack

const MOVE_RANGE = [Vector2(-3,0),Vector2(-2,0), Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(3,0)]
const ATTACK_RANGE = [Vector2(0,0)]

var grid_pos : Vector2
var AI = preload("res://Resources/EnemyAI/EnemyAIBasic.gd").new()

var current_state = STATES.IDLE
var decision : EnemyDecision

var _tween : Tween

func _ready():
	pass

# make decision to display to player
func make_decision():
	decision = AI.pick_action(self)
	
# decision only decides the action, not how it's done.
func execute_decision():
	match decision.action:
		Constants.ENEMY_ACTIONS.MOVE:
			play("idle")
			# find closest unit
			var closest = null
			var min_dist = 999
			for unit in Global.units.values():
				if !unit:
					continue
				if grid_pos.distance_to(unit.grid_pos) < min_dist:
					min_dist = grid_pos.distance_to(unit.grid_pos)
					closest = unit
			
			# find tiles in range
			var range = []
			for v in MOVE_RANGE:
				if Global.grid.is_within_bounds(grid_pos + v):
					range.append(grid_pos + v)
			
			# find closest movable square
			var target = grid_pos
			min_dist = target.distance_to(closest.grid_pos)
			for v in range:
				if closest.grid_pos.distance_to(v) < min_dist:
					min_dist = closest.grid_pos.distance_to(v)
					target = v
					
			# move
			move_straight(Global.grid_to_tile[target].global_position, 75)
			Global.enemies[grid_pos] = null
			Global.enemies[target] = self
			grid_pos = target
			
			await continue_action
			
			# if target tile has a unit, wind up an attack
			if Global.units[target]:
				current_state = STATES.WINDUP
				play("windup")
			
			SignalBus.emit_signal('activate_grid')
			
		Constants.ENEMY_ACTIONS.ATTACK:
			if current_state == STATES.WINDUP:
				current_state = STATES.IDLE
				play("attack")
			else:
				current_state = STATES.WINDUP
				play("windup")
				
			SignalBus.emit_signal('activate_grid')

# new pos is vector2 for new global position.
func move_straight(new_pos, speed):
	var dist = global_position.distance_to(new_pos)
	var time = dist / speed
	_tween = get_tree().create_tween()
	_tween.tween_property(self, 'global_position', new_pos, time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	_tween.tween_callback(emit_signal.bind('continue_action'))

# deal and take damage
func attack():
	pass
	
func take_damage():
	pass


func _on_animation_finished():
	pass # Replace with function body.
