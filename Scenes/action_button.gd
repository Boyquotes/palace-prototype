extends Button

var action : Action

func _on_pressed():
	Global.play_sfx('blip.wav')
	SignalBus.emit_signal('action_chosen', action)
