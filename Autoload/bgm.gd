extends AudioStreamPlayer

var _tween : Tween

func play_song(path):
	stream = load('res://Assets/Sounds/Music/' + path)
	
func duck():
	#_tween = get_tree().create_tween()
	pass
	
func unduck():
	pass
