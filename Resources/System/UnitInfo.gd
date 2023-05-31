# contains all info for a unit
class_name UnitInfo
extends Resource

signal ui_update

var max_health = 100
var health = 100 : set = _set_health

func _init(_health):
	max_health = _health
	health = _health

func _set_health(value):
	value = clamp(value, 0, max_health)
	health = value
	emit_signal('ui_update')
