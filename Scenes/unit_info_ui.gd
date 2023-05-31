extends Control

var unit_info : UnitInfo

@onready var bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func initialize():
	bar.max_value = unit_info.health
	bar.value = unit_info.health
	
	unit_info.ui_update.connect(_on_UI_Update)

func _on_UI_Update():
	bar.value = unit_info.health

func _on_mouse_entered():
	print('mouse entered')
