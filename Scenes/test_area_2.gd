extends Node2D

# actions are specific to units
# buttons need to know which data to send to point to specific action
# main scene needs to know action range, action type, action length
# unit needs to change animation depending on which action its performing

const TILE_SCENE = preload("tile.tscn")
enum MODES {GRID_SELECT, ACTION_SELECT, WATCH_PHASE}
enum PHASES {PLAYER, ENEMY}

@onready var player_unit = $Units/avatar
@onready var enemy_unit = $Enemies/enemy

var _grid : Grid

var current_mode = MODES.GRID_SELECT
var current_phase = PHASES.PLAYER
var selected_action : Action
var selected_tile
var selected_unit

var button_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Bgm.play_song('mysterious_loop.ogg')
	
	# connect signals
	SignalBus.tile_selected.connect(_on_Tile_Selected)
	SignalBus.action_chosen.connect(_on_Action_Chosen)
	SignalBus.activate_grid.connect(_on_Activate_Grid)
	
	_grid = Grid.new(Vector2(7,4), Vector2(25,25))
	Global.grid = _grid
	
	for i in _grid.size.x:
		for j in _grid.size.y:
			var new_tile = TILE_SCENE.instantiate()
			new_tile.position = 25 * Vector2(i,j)
			$Grid.add_child(new_tile)
			
			new_tile.grid_pos = Vector2(i, j)
			
			Global.grid_to_tile[Vector2(i, j)] = new_tile
			Global.units[Vector2(i, j)] = null
			Global.enemies[Vector2(i, j)] = null
			
	player_unit.grid_pos = Vector2(1, 3)
	enemy_unit.grid_pos = Vector2(6, 3)
	
	player_unit.global_position = Global.grid_to_tile[player_unit.grid_pos].global_position
	enemy_unit.global_position = Global.grid_to_tile[enemy_unit.grid_pos].global_position
			
	Global.units[player_unit.grid_pos] = player_unit
	Global.enemies[enemy_unit.grid_pos] = enemy_unit
	
	for enemy in Global.enemies.values():
		if enemy:
			enemy.make_decision()
	
	initialize_buttons()
	$UI/enemy_info_ui.unit_info = enemy_unit.enemy_info
	$UI/unit_info_ui.unit_info = player_unit.unit_info
	$UI/enemy_info_ui.initialize()
	$UI/unit_info_ui.initialize()

func initialize_buttons():
	for unit in $Units.get_children():
		for action in unit.ACTIONS.values():
			var new_button = load('res://Scenes/action_button.tscn').instantiate()
			new_button.action = action
			new_button.theme = action.button_theme
			#new_button.text = action.name
			button_dict[action] = new_button
			$Buttons/HFlowContainer.add_child(new_button)
			
	for button in $Buttons/HFlowContainer.get_children():
		button.visible = false

func deselect_unit():
	for button in $Buttons/HFlowContainer.get_children():
		button.visible = false
	
	$Buttons.visible = false
	selected_unit = null
			
func select_unit(unit):
	for action in unit.available_actions():
		button_dict[action].visible = true
	
	$Buttons.visible = true
	selected_unit = unit

# is now 'on phase end'
func _on_Activate_Grid():
	match current_phase:
		PHASES.PLAYER:
			current_phase = PHASES.ENEMY
			for enemy in Global.enemies.values():
				if enemy:
					enemy.execute_decision()
				
		PHASES.ENEMY:
			current_phase = PHASES.PLAYER
			current_mode = MODES.GRID_SELECT
			
			for enemy in Global.enemies.values():
				if enemy:
					enemy.make_decision()
	
	

func _on_Tile_Selected(tile):
	match current_mode:
		MODES.GRID_SELECT:
			if selected_tile == tile:
				tile.deselect()
				selected_tile = null
				deselect_unit()
				return
			
			if selected_tile:
				selected_tile.deselect()
				selected_tile = null
				deselect_unit()
			
			if Global.units[tile.grid_pos]:
				tile.select()
				selected_tile = tile
				select_unit(Global.units[selected_tile.grid_pos])
			
		
		MODES.ACTION_SELECT:
			
			if tile.available:
				Global.play_sfx('blip2.wav')
				current_mode = MODES.WATCH_PHASE
				selected_tile.deselect()
				selected_tile = null
				# move unit
				selected_unit.perform_action(selected_action, tile.grid_pos)
			
				deselect_unit()
			else:
				current_mode = MODES.GRID_SELECT
				
			clear_tiles()
			
		MODES.WATCH_PHASE:
			pass
			
#----------------ACTIONS-------------------
func _on_Action_Chosen(action):
	current_mode = MODES.ACTION_SELECT
	selected_action = action
	
	clear_tiles()
	
	var base = selected_unit.grid_pos
	for v in action.range:
		var p = base + (v * selected_unit.direction)
		if _grid.is_within_bounds(p):
			Global.grid_to_tile[p].set_available(action.type)
			
func clear_tiles():
	for i in range(_grid.size.x):
		for j in range(_grid.size.y):
			Global.grid_to_tile[Vector2(i,j)].clear()
		
