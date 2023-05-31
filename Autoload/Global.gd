extends Node

const SFX_SCENE = preload('res://Scenes/sfx.tscn')

var grid : Grid

var grid_to_tile = {}

var units = {}
var enemies = {}

func play_sfx(path, _random=null, _range=null):
	var s = load('res://Assets/Sounds/SFX/' + path)
	var sfx = SFX_SCENE.instantiate()
	
	if _random:
		sfx.random = _random
		
	if _range:
		sfx.range = _range
	
	sfx.stream = s
	
	add_child(sfx)
