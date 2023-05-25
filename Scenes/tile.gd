extends Node2D

const TILE_DEFAULT = preload("res://Assets/Sprites/tile.png")
const TILE_HOVERED = preload("res://Assets/Sprites/tile_hovered.png")
const TILE_SELECTED = preload("res://Assets/Sprites/tile_selected.png")

var grid_pos : Vector2

var selected = false # make this setget
var available = false

var movable = false : set = _set_movable
var attackable = false : set = _set_attackable

func _set_movable(value):
	movable = value
	$Move_Sprite.visible = movable
	
func _set_attackable(value):
	attackable = value
	$Attack_Sprite.visible = attackable

func clear():
	available = false
	$Move_Sprite.visible = false
	$Attack_Sprite.visible = false

func set_available(type):
	available = true
	match type:
		Constants.ACTION_TYPES.MOVEMENT:
			$Move_Sprite.visible = true
		Constants.ACTION_TYPES.ATTACK:
			$Attack_Sprite.visible = true
		Constants.ACTION_TYPES.SKILLS:
			pass

func select():
	selected = true
	$Sprite2D.texture = TILE_SELECTED
	
func deselect():
	selected = false
	$Sprite2D.texture = TILE_DEFAULT

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				SignalBus.emit_signal('tile_selected', self)


func _on_area_2d_mouse_entered():
	if !selected:
		$Sprite2D.texture = TILE_HOVERED


func _on_area_2d_mouse_exited():
	if !selected:
		$Sprite2D.texture = TILE_DEFAULT
	
